require 'sqlite3'
require 'active_record'

db_file = '../database/database.db'
db = SQLite3::Database.new db_file
db.execute <<-SQL
  create table post(
    name varchar(30),
    password varchar(30)
  )
SQL

=begin
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3', database: db_file)

class Post < ActiveRecord::Base
end
Post.create name: 'name', password: 'password'
=end
