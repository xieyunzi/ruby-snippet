context = IO.read('test.txt')

#<img alt="" src="http://pic.mmkao.com/photo/PANS/PANS232/19.jpg">
img_reg = %r{http://pic.mmkao.com/photo/.+\.jpg}
#<a href="5735_3.html">上一页</a>
page_reg = %r{(?:<a\s+href=")([\d_]+\.html)}

images = context.scan(img_reg).uniq
pages = context.scan(page_reg).uniq

puts images, pages