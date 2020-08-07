require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id
  def initialize(id = nil,name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql ="
        CREATE TABLE IF NOT EXISTS students
        (id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER)"
    DB[:conn].execute(sql)
  end

  def self.drop_table

    sql = "DROP TABLE students"
      DB[:conn].execute(sql)
  end

def save

  if self.id
    self.update
  else

    sql = "INSERT INTO students(name, grade)
    VALUES(?,?)"
      DB[:conn].execute(sql, self.name,self.grade)
      @id =DB[:conn].execute("SELECT last_insert_rowid()
      FROM students")[0][0]
  end
end
def self.create(name, grade)
  new_students = Student.new(name, grade)
  new_students.save
end

def self.new_from_db(arr)
  id = arr[0]
  name = arr[1]
  grade = arr[2]
  Student.new(id,name,grade)
end
def self.find_by_name(name)
    sql ="SELECT * FROM students
    WHERE name = ? LIMIT 1"
    DB[:conn].execute(sql,name).map do |value|
       self.new_from_db(value)
    end.first
 end

 def update

   sql = "UPDATE students
        SET name = ?, grade =?
        WHERE id = ?"
    DB[:conn].execute(sql,self.name,self.grade,self.id)
end
end
