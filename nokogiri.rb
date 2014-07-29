require 'open-uri'
require 'nokogiri'

# Perform a google search
doc = Nokogiri::HTML(open('http://bing.com/search?q=love'))

puts doc.inspect

# Print out each link using a CSS selector
doc.css('h2 > a').each do |link|
  puts link.content
end
