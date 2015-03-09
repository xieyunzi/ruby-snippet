class MyMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['PATH_INFO'] == '/hello'
      [200, { 'Content-Type' => 'text/plain' }, ['Hello from the middleware.']]
    else
      env['nothing'] = 'nothing'
      @app.call(env)
    end
  end
end
