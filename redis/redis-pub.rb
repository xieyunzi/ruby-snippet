# usage:
# ruby pub.rb channel username

require 'redis'
require 'json'

redis = Redis.current

channel, user = ARGV[0], ARGV[1]

data = { 'user' => user }

loop do
  msg = STDIN.gets
  redis.publish channel, data.merge('msg' => msg.strip).to_json
end
