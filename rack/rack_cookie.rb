require 'rack'
require 'pp'

app = Proc.new do |env|
  request = Rack::Request.new(env)
  pp request.cookies

  response = Rack::Response.new('a love story')
  response.set_cookie 'ok', 'haha?'

  response.finish
end

Rack::Server.start(
  app: app,
  server: 'thin',
  Host: '0.0.0.0'
) do
  use Rack::Session::Cookie, key: 'rack.session',
                             path: '/',
                             expire_after: 2592000,
                             secret: 'change_me',
                             old_secret: 'also_change_me'
end
