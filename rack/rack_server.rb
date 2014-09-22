require 'rack'

Rack::Server.start(
  app: lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['a love story']] },
  server: 'thin'
)
