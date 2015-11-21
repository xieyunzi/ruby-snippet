# https://robots.thoughtbot.com/redis-partial-word-match-you-auto-complete-me

require 'redis'

redis = Redis.current

movies = ['Bad Santa', 'Batman', 'Bad Company']

set = {}

movies.each_with_index do |element, i|
  redis.set "movies:#{i}", element

  element.length.times do |j|
    partial = element[0..j].downcase
    key = "index:#{partial}:movies"

    (set[key] || (set[key] = [])) && set[key].push(i)
  end
end

set.each { |k, v| redis.sadd(k, v) }

# autocomplete.rb
class Autocomplete
  attr_reader :partial_word

  def initialize(partial_word)
    @partial_word = partial_word.downcase
  end

  def movies
    redis.sort "index:#{partial_word}:movies", by: :nosort, get: 'movies:*'
  end

  private

  def redis
    Redis.current
  end
end

puts Autocomplete.new('ba').movies
