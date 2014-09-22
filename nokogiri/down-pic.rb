# 下载图片，存入文件系统
require 'open-uri'

pic_url = "http://lolimp.pl/images/20120609/2473/m-so-young-so-naive.png"
data = open(pic_url) { |f| f.read }
open('ruby.png', 'wb') { |f| f.write(data) }
