require './my_app'
require './my_rack_middleware'
require './my_middleware'

use Rack::Reloader
use MyRackMiddleware
use MyMiddleware

run MyApp.new
