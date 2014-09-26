require 'webrick'

class RootPath < WEBrick::HTTPServlet::AbstractServlet
  def service req, res
    status, headers, body = [200, {'Content-Type' => 'text/plain'}, "root path. now: #{Time.now}"]

    res.status = status
    headers.each { |k, v| res[k] = v }
    res.body = body

    puts res
  end
end

server = WEBrick::HTTPServer.new Port: 8000
server.mount '/', RootPath
trap 'INT' do server.shutdown end
server.start
