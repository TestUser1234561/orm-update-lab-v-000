require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @grade = grade
    @name = name
  end

  def self.new_from_db(row)
    new(row[0], row[1], row[2])
  end

  def self.all
    DB[:conn].execute("select * from students").map { |row| Student.new_from_db(row) }
  end

  def self.find_by_name(name)
    DB[:conn].prepare("select * from students where name = ? limit 1").execute([name]).each { |row| return Student.new_from_db(row) }
  end

  def save
    sql = <<-SQL
      INSERT INTO students (id, name, grade)
      VALUES (max(id) + 1, ?, ?)
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
