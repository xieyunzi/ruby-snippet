require 'socket'

header = "HTTP/1.1 200 OK\n" +
  "Server: xyz-server\n" +
  "\r\n"
body = "hello !"

server = TCPServer.new '127.0.0.1', 8000
while true
  client = server.accept
  client.puts (header + body)
  client.close
end
