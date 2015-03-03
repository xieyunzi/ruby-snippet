require 'socket'
require 'logger'

logger = Logger.new(STDOUT)

socket = Socket.new :INET, :STREAM
addr = Socket.pack_sockaddr_in 4481, '0.0.0.0'
logger.debug addr.class
socket.bind(addr)
#socket.bind(Addrinfo.tcp('0.0.0.0', 4480))
socket.listen Socket::SOMAXCONN

loop do
  connection, _ = socket.accept

  logger.debug _.class
  logger.debug connection.gets

  connection.close
end
