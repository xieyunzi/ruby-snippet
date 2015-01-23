require 'net/http'

uri = URI('http://www.oschina.net')

Net::HTTP.start uri.host, uri.port do |http|
  request = Net::HTTP::Get.new uri

  response = http.request request

  puts response.body
end
