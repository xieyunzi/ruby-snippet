class MyMiddle
  def initialize(app)
    @app = app
  end

  def call(env)
    puts '='*60, 'CLASS_MyMiddle'
    @app.call(env)
  end
end

map '/map' do
  run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['This is publish page']] }
end

map '/map1' do
  use MyMiddle
  run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['This is publish page']] }
end

map '/map2' do
  run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['This is publish page']] }
end

use Rack::CommonLogger
use MyMiddle

map '/secret' do
  map '/' do
    run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['This is a secret page']] }
  end

  map '/files' do
    map '/files' do
      map '/files' do
        run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['Here are the secret files']] }
      end

      map '/files1' do
        run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['Here are the secret files']] }
      end

      map '/files2' do
        run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['Here are the secret files']] }
      end
    end

    map '/files1' do
      run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['Here are the secret files']] }
    end

    map '/files2' do
      run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['Here are the secret files']] }
    end

    map '/langlangfile' do
      run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['Here are the secret files']] }
    end

    run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['Here are the secret files']] }
  end
end
