require 'open-uri'
require 'simple-rss'
require 'hashie'
require 'pry'

def rss
  rss_url = 'http://status.kaopubao.com/feed'
  SimpleRSS.parse open(rss_url)
end

def raw_articles(rss)
  raw_articles = []
  rss.items.each do |item|
    raw_articles.push Hashie::Mash.new \
      title: item.title,
      created_at: item.pubDate,
      #summary: item.description,
      link: item.link
  end

  raw_articles
end

articles = raw_articles(rss)
binding.pry
#puts articles
