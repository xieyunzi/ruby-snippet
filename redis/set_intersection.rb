# https://robots.thoughtbot.com/redis-set-intersection-using-sets-to-filter-data

require 'redis'
require 'time'

class String
  def parameterize
    downcase.gsub(/\s/, '-')
  end
end

redis = Redis.current

sample = '|Id|Departure Time|Airline|Departure City|Arrival City| |1|03/23/2013 1:30 pm|Virgin America|Los Angeles|New York| |2|03/23/2013 1:45 pm|Virgin America|San Francisco|New York| |3|03/23/2013 1:45 pm|American Airlines|San Francisco|New York| |4|03/23/2013 1:50 pm|American Airlines|Los Angeles|Boston| |5|03/23/2013 2:45 pm|Southwest|San Francisco|New York| |6|03/23/2013 3:30 pm|Southwest|San Francisco|New York|'
data =
  sample.split('| |').inject([]) do |a, line|
    a.push line.split('|')
  end.tap { |a| a.shift }

data.each_with_index do |d, i|
  redis.set "flights:#{i}", d.join(', ')

  time = Time.strptime(d[1], '%m/%d/%Y %I:%M %p').to_i
  redis.sadd "departure_time:#{time}:flights", i

  redis.sadd "cities:#{d[3].parameterize}:departures", i
  redis.sadd "cities:#{d[4].parameterize}:arrivals", i
end

# Find flights from San Francisco to New York
# sinter cities:san-francisco:departures cities:new-york:arrivals

class Window
  ONE_HOUR_IN_SECONDS = 3600

  def initialize(start_at, end_at)
    @start_at = convert_to_epoch(start_at)
    @end_at = convert_to_epoch(end_at)
  end

  def range_keys
    (start_at..end_at).step(five_mins).map do |epoch_time|
      yield epoch_time
    end
  end

  private

  attr_reader :start_at, :end_at

  def convert_to_epoch(string_time)
    Time.strptime(string_time, '%m/%d/%Y %I:%M %p').to_i
  end

  def five_mins
    ONE_HOUR_IN_SECONDS / 12
  end
end

class FlightFinder
  def initialize(attrs)
    @arrival_city = attrs[:arrival_city].parameterize
    @departure_city = attrs[:departure_city].parameterize
    @window = attrs[:window]
  end

  def flights
    redis.mget(*flight_keys)
  end

  private

  attr_reader :arrival_city, :departure_city, :window

  def flight_keys
    flight_ids.map { |id| "flights:#{id}" }
  end

  def flight_ids
    redis.multi do
      redis.sunionstore 'temp_set', *departure_time_keys
      redis.sinter 'temp_set', departure_cities_key, arrival_cities_key
    end.last
  end

  def departure_cities_key
    "cities:#{departure_city}:departures"
  end

  def arrival_cities_key
    "cities:#{arrival_city}:arrivals"
  end

  def departure_time_keys
    window.range_keys { |epoch_time| "departure_time:#{epoch_time}:flights" }
  end

  def redis
    Redis.current
  end
end

# -----------------

window = Window.new(
  '3/23/2013 1:00 pm',
  '3/23/2013 3:00 pm'
)

flight_finder = FlightFinder.new(
  departure_city: 'San Francisco',
  arrival_city: 'New York',
  window: window
)

puts flight_finder.flights
