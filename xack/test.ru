use Rack::CommonLogger

run Proc.new { |env|
  content = { script_name: env['SCRIPT_NAME'], path_info: env['PATH_INFO'] }.to_s
  [200, { 'Content-Type' => 'text/html' }, [content + 'Hello world!']]
}
