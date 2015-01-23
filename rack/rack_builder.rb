require 'rack'
require 'pry-byebug'

=begin
app = Rack::Builder.new do
  use Rack::Lint
#    byebug
  map '/ok' do
#    use Rack::ShowStatus
    run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['OK']] }
  end

  map '/hehe' do
    use Rack::CommonLogger
  end

#  use Rack::Lint
  run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['hehe']] }
end
#Rack::Handler::Thin.run app, :Port => 8080, debug: true
Rack::Server.start app: app, Port: 8080, debug: true
=end


app = Rack::Builder.new do
  infinity = Proc.new {|env| [200, {"Content-Type" => "text/html"}, [env.inspect]]}

  use Rack::CommonLogger
  use Rack::ShowExceptions

  map '/' do
    run infinity
  end

  map '/ok' do
#    use Rack::ShowStatus
    run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['OK']] }
  end

  map '/version' do
    map '/' do
      run Proc.new {|env| [200, {"Content-Type" => "text/html"}, ["infinity 0.1"]] }
    end

    map '/hehe' do
      use Rack::CommonLogger
      run lambda { |env|
        require 'pp'
  #      pp env
        [200, {'Content-Type' => 'text/plain'}, ['hehe']]
      }
    end

    map '/last' do
      run Proc.new {|env| [200, {"Content-Type" => "text/html"}, [Rack::Request.new(env).params.inspect]] }
    end
  end

  run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['app']] }
end
Rack::Server.start app: app, Port: 8080, debug: true
