require 'socket'

server = TCPServer.new('127.0.0.1', 3333)

while session = server.accept
  session.puts 'hello world.'
  session.puts "#{Time.now}"
  session.close
end
