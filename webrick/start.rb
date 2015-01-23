require 'webrick'

server = WEBrick::HTTPServer.new(BindAddress: 'localhost', Port: 8080)

begin
  server.start
ensure
  server.shutdown
end
