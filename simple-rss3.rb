require 'open-uri'
require 'hashie'
require 'nokogiri'
require 'pry'

def rss
  rss_url = 'http://status.kaopubao.com/feed'
  Nokogiri::XML(open(rss_url))
end

def raw_articles(rss)
  raw_articles = []
  items = rss.css('channel item')

  items.each do |item|
    puts item.css('title').text,
      item.css('pubDate').text,
      Nokogiri::HTML(item.css('description').to_html).css('p.lead').text,
      item.css('link').text
  end

  raw_articles
end

articles = raw_articles(rss)
binding.pry
#puts articles
