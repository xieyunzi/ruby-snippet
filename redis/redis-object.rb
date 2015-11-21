require 'redis'

redis_store = 'redis://localhost:6379/1/cache'
redis = Redis.new url: redis_store

key = 'life.dream'
redis.set key, 'a long story'
redis.set key, 'a long story'

puts redis.get(key), Redis.current.inspect

