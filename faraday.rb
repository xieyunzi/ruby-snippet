require 'faraday'

conn = Faraday.new(url: 'http://image.baidu.com') do |faraday|
  faraday.request :url_encoded
  faraday.response :logger
  faraday.adapter Faraday.default_adapter
end

response = conn.get
puts response.body
