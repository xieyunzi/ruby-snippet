class Hello
  def self.call(env)
    [
      200,
      {'ContentType' => 'text/plain'},
      ['Hello from Rack!']
    ]
  end
end

run Hello
