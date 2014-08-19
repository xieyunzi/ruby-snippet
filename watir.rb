require 'watir-webdriver'

b = Watir::Browser.new :firefox
#b.goto 'https://github.com/ansoni/watir-extensions-element-screenshot'
b.goto 'http://oschina.net'
b.screenshot.save("oschina.png")
