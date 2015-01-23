require 'rubygems'
require 'rack'

require 'pry'
require 'warden'

def application(env)
  binding.pry
  [200, {"Content-Type" => "text/html"}, "Hello Rack!"]
end

Rack::Handler::WEBrick.run method(:application), :Port => 9292

