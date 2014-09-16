require 'sqlite3'
require 'active_record'
require 'yaml'

config = YAML.load_file('config/database.yml')
dbfile = config['development']['database']

unless File.exist? dbfile
  SQLite3::Database.new dbfile
end

class User < ActiveRecord::Base; end

ActiveRecord::Base.establish_connection(config['development'])

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'users'
    create_table :users do |t|
      t.column :username, :string
      t.column :password, :string
    end
  end
end

#User.create username: 'xieyunzi', password: 'password'
puts User.all.inspect
