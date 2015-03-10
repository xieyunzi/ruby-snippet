use Rack::CommonLogger

map '/' do
  run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['This is publish page']] }
end
map '/secret' do
  map '/' do
    run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['This is a secret page']] }
  end
  map '/files' do
    run Proc.new { |env| [200, {'Content-Type' => 'text/html'}, ['Here are the secret files']] }
  end
end
