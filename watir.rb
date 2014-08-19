require 'watir-webdriver'

b = Watir::Browser.new :firefox
#b.goto 'http://kaopubao.staging.bpct.co'
#b.goto 'http://lofter.com'
5.times do |i|
  b.goto "http://slides.com/dhanishsemarshahul/crobats-week-2#/#{i}"
  b.screenshot.save("image#{i}.png")
end
