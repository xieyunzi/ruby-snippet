# Usage: redis-cli publish message.achannel hello

require 'sinatra'
require 'redis'

conns = Hash.new {|h, k| h[k] = [] }

Thread.abort_on_exception = true

get '/' do
  erb :index
end

get '/subscribe/:channel' do
  content_type 'text/event-stream'

  stream(:keep_open) do |out|
    channel = params[:channel]

    conns[channel] << out

    out.callback do
      conns[channel].delete(out)
    end
  end
end

Thread.new do
  redis = Redis.connect

  redis.psubscribe('message', 'message.*') do |on|
    on.pmessage do |match, channel, message|
      channel = channel.sub('message.', '')

      conns[channel].each do |out|
        out << "event: #{channel}\n\n"
        out << "data: #{message}\n\n"
      end
    end
  end
end

__END__

@@ index
  <article id="log"></article>

  <script>
    var source = new EventSource('/subscribe/achannel');

    source.addEventListener('message', function (event) {
      document.getElementById('log').textContent += '\n' + event.data;
    }, false);
  </script>
