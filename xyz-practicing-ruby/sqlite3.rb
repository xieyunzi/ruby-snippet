require 'sqlite3'
require 'active_record'
require 'sinatra'

dbfile = './db3.db'

unless File.exist? dbfile
  SQLite3::Database.new dbfile
end

class User < ActiveRecord::Base; end

configure do
  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: dbfile
  )
end

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'users'
    create_table :users do |t|
      t.column :username, :string
      t.column :password, :string
    end
  end
end

get '/users' do
  @users = User.all
  haml :user_index
end

post '/users' do
  User.create username: 'xieyunzi', password: 'password'
end

__END__

@@ layout
!!!
%html
  %head
    %link{rel: :stylesheet, href: 'http://cdn.bootcss.com/bootstrap/3.2.0/css/bootstrap.min.css'}
    %title sinatra app
  %body
    .container-fluid
      = yield

@@ user_index
%table.table
  %thead
    %tr
      %td username
      %td password
  %tbody
    - @users.each do |u|
      %tr
        %td=u.username
        %td=u.password
