require "socket"
 
webserver = TCPServer.new('localhost', 2000) 
base_dir = Dir.new(".")
while (session = webserver.accept)
  session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
  
  request = session.gets
  trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')
  if trimmedrequest.chomp != ""
    base_dir = Dir.new("./#{trimmedrequest}".chomp)
  end
  session.print "<p>#{trimmedrequest}</p>"
  
  session.print("#{base_dir}")
  if Dir.exists? base_dir
     base_dir.entries.each do |f|
       if File.directory? f
         session.print("<a href='#{f}'> #{f}</a>")
       else
        session.print("<p>#{f}</p>")
       end 
     end
  else
    session.print("Directory does not exists!")
  end
  session.close 
end