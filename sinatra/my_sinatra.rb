require 'sinatra'

class RackMiddleware
  def initialize(appl)
    @appl = appl
  end
  def call(env)
    start = Time.now
    status, headers, body = @appl.call(env) # call our Sinatra app
    stop = Time.now
    puts "Response Time: #{stop - start}" # display on console
    [status, headers, body]
  end
end


configure do
  set :bind, '0.0.0.0'
end

use RackMiddleware
get '/' do
  'welcome to all.'
end
