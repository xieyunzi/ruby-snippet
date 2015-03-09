require 'json'

class Hello
  def self.call(env)
    [
      200,
      {'ContentType' => 'text/plain'},
      ["<pre>#{env.to_h.to_json}</pre>"]
    ]
  end
end

run Hello
