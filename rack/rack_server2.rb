require 'rack'

class App
  def call(env)
    env.each { |k, v| puts "#{k.ljust(22)}: #{v}" }

    [200, {'Content-Type' => 'text/plain'}, ["[server_software: #{env['SERVER_SOFTWARE']}] a long story"]]
  end
end

Rack::Server.start(
  app: App.new,
  server: 'thin'
)
