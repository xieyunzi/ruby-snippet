require "socket" 

webserver = TCPServer.new('localhost', 2000) 
while (session = webserver.accept)
  session.write(Time.now)
  session.print("Hello World!")
  session.close 
end