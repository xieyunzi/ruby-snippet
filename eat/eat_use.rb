require './eat'

#root = 'http://oschina.net'
root = 'http://dbmeizi.com'
#root = 'http://163.com'
#root = 'http://image.baidu.com'
#page = Eat::Page.new(root)
#puts page.links
#puts page.images

core = Eat::Core.new(root, depth_limit: 1, verbose: true)
core.run
core.pages.each do |k, page|
  puts "page.status: #{page.status}"
  puts "page.body: #{page.body}"
  puts "page.response_time: #{page.response_time}"
end
