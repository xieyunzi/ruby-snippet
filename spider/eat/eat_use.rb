require './eat'

#root = 'http://www.oschina.net'
root = 'http://dbmeizi.com'
#root = 'http://image.baidu.com'
#page = Eat::Page.new(root)
#puts page.links
#puts page.images

core = Eat::Core.new(root, depth_limit: 1, verbose: true)
core.run
puts core.pages
