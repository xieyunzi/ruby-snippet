require 'open-uri'
require 'simple-rss'
require 'pry'

rss = SimpleRSS.parse open('http://status.kaopubao.com/feed')
rss.items.each do |item|
  puts item.title
  puts item.pubDate
  puts item.description
  puts item.link

  binding.pry
end
