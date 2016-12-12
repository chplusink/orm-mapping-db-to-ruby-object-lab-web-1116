class Student
  attr_accessor :id, :name, :grade

  def initialize(attributes={})
    attributes.each do |key,value|
      self.send("#{key}=",value)
    end
  end

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    students = DB[:conn].execute("SELECT * FROM students")
    students.collect do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    student = DB[:conn].execute("SELECT * FROM students WHERE name = '#{name}'")
    self.new_from_db(student[0])
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
  end

  def self.first_x_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
    SQL
    DB[:conn].execute(sql,num)
  end

  def self.first_student_in_grade_10
    DB[:conn].results_as_hash = true
    student = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1")[0]
    self.new_from_db(student)
  end

  def self.all_students_in_grade_x(grade)
    DB[:conn].execute("SELECT * FROM students WHERE grade = #{grade}")
  end

end
