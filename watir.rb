require 'watir-webdriver'
require 'chunky_png'



module Watir
  class Element
    def screenshot(dest)
      file = Tempfile.new('sc')
      begin
        browser.screenshot.save(file)
        image = ChunkyPNG::Image.from_file(file)

        puts image.width, image.height

        image.crop!(wd.location.x, wd.location.y, wd.size.width, wd.size.height)
        image.save(dest)
      ensure
        file.unlink
      end
    end

    def so_size
      puts wd.location.inspect, wd.size.inspect
    end
  end
end

b = Watir::Browser.new :firefox
#b.goto 'http://kaopubao.staging.bpct.co'
#b.goto 'http://lofter.com'
=begin
5.times do |i|
  b.goto "http://slides.com/dhanishsemarshahul/crobats-week-2#/#{i}"
  b.screenshot.save("image#{i}.png")
end
=end

b.goto 'http://so.com'
b.body.so_size
b.body.screenshot('so.png')
