require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :name, :grade, :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade INTEGER
    )"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?,?)"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

    end
  end

  def self.new_from_db(row)
    new_student = self.new(row[1], row[2], row[0])
#    new_student.id = row[0]
#    new_student.name = row[1]
#    new_student.grade = row[2]
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    new_student = DB[:conn].execute(sql, name)
    new_arr = new_student[0]
    new_instance = Student.new(new_arr[1], new_arr[2], new_arr[0])
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end




  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
