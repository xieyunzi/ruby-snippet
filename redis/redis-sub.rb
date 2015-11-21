# https://robots.thoughtbot.com/redis-pub-sub-how-does-it-work
#
# usage:
# ruby sub.rb channel...

require 'redis'
require 'json'

redis = Redis.current

redis.subscribe(*ARGV) do |on|
  on.message do |channel, msg|
    data = JSON.parse(msg)
    puts "##{channel} - [#{data['user']}]: #{data['msg']}"
  end
end
