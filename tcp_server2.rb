require 'socket'

server = TCPServer.new('127.0.0.1', 3333)
base_dir = Dir.new('.')

while session = server.accept
  puts "[#{Time.now}: get request] " + session.gets
  session.puts "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"

  base_dir.sort.each do |file|
    if File.directory? file
      session.puts "#{file}/"
    else
      session.puts "#{file}"
    end
  end

  session.close
end
