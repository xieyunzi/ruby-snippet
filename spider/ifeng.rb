require 'anemone'

Anemone.crawl 'http://cn.bing.com', depth_limit: 1, storage: Anemone::Storage.SQLite3 do |anemone|
  anemone.after_crawl do |pages|
    pages.each_value do |page|
      puts page.headers, page.body.force_encoding('utf-8')
    end
  end
end
