require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    stu = new()
    stu.id = row[0]
    stu.name = row[1]
    stu.grade = row[2]
    stu
  end

  def self.all
    DB[:conn].execute("select * from students").map { |row| Student.new_from_db(row) }
  end

  def self.find_by_name(name)
    DB[:conn].prepare("select * from students where name = ? limit 1").execute([name]).each { |row| return Student.new_from_db(row) }
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
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end