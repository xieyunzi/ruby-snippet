require "socket"


webserver = TCPServer.new('localhost', 2000)
base_dir = Dir.new(".")
while (session = webserver.accept)
  request = session.gets
  puts request
  trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '').chomp
  resource =  trimmedrequest

  if resource == ""
    resource = "."
  end
  print resource

  if !File.exists?(resource)
    session.print "HTTP/1.1 404/Object Not Found\r\nServer Matteo\r\n\r\n"
    session.close
    next
  end

  if File.directory?(resource)
    session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
    if resource == ""
      base_dir = Dir.new(".")
    else
      base_dir = Dir.new("./#{trimmedrequest}")
    end
    base_dir.entries.each do |f|
      dir_sign = ""
      base_path = resource + "/"
      base_path = "" if resource == ""
      resource_path = base_path + f
      if File.directory?(resource_path)
        dir_sign = "/"
      end
      if f == ".."
        upper_dir = base_path.split("/")[0..-2].join("/")
        session.print("<a href=\"/#{upper_dir}\">#{f}/</a></br>")
      else
        session.print("<a href=\"/#{resource_path}\">#{f}#{dir_sign}</a></br>")
      end
    end
  else
     ## return file
  end
  session.close
end
