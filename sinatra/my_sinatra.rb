require 'sinatra'
require './rack_middleware'

use RackMiddleware
get '/' do
  'welcome to all.'
end
