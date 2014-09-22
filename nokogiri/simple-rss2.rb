require 'open-uri'
require 'simple-rss'
require 'hashie'
require 'haml'
require 'pry'

rss = SimpleRSS.parse open('http://status.kaopubao.com/feed')
raw_articles = []

rss.items.each do |item|
  raw_articles << {
    title: item.title,
    created_at: item.pubDate,
    summary: item.description,
    link: item.link
  }.to_hash
end

views_path = File.expand_path('../asset',  __FILE__)
news_template = File.read(views_path + '/_news.html.haml')
haml_engine = Haml::Engine.new news_template
binding.pry
news_render = haml_engine.render Object.new, raw_articles: raw_articles

puts news_render
