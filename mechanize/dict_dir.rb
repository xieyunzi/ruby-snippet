# 抓取 http://dict.cn/dir/ 中的星级词汇

require 'sqlite3'
require 'active_record'
require 'mechanize'
require 'nokogiri'
require 'byebug'

# create db and table
db_file = '../database/dict_dir.db'
sql_create_table = %q(
  CREATE TABLE IF NOT EXISTS pages (
    url varchar(255),
    content text
  )
)
SQLite3::Database.new(db_file).execute(sql_create_table)

# create model
class Page < ActiveRecord::Base
  self.primary_key = 'url'
end

# establish db connection
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: db_file)

# for test
# Page.create url: 'cc', content: 'ss'
# puts Page.select(:url).all.inspect

def crawl
  # agent
  a = Mechanize.new do |agent|
    agent.user_agent_alias = 'Mac Safari'
    agent.follow_meta_refresh = true
  end

  a.get('http://dict.cn/dir/') do |page|
    page.links_with(href: /base/).each do |link|
      puts link.href # log
      Page.create url: link.href,
                  content: a.get_file("http://dict.cn#{link.href}")
    end
  end
end

# crawl # uncomment this line
# puts Page.select(:url).all.inspect

# parse
wordslist = ''
Page.all.each do |page|
  header = page.url.slice /base[\d\-]*/
  doc = Nokogiri::HTML(page.content)
  words = doc.css('.hub-detail-group > ul > li > a').text.split(' 的意思')

  wordslist << words.unshift("\#\# #{header}").join("\n") + "\n"
  # byebug
end
puts wordslist

# userage
# ruby thisfile.rb >> wordslist
