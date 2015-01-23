require 'net/http'
require 'uri'

class Grub
  USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:20.0) Gecko/20100101 Firefox/20.0'

  def initialize url
    uri = URI.parse url
    @http =  Net::HTTP.new uri.host, uri.port
    @req = Net::HTTP::Get.new uri.request_uri
    @cookie = nil
  end

  def get_page
    response = @http.request request
    # update cookie
    cookie response['set-cookie']
    response.body
  end

  def cookie cookie=nil
    if cookie
      @cookie = cookie
    else
      @cookie ||= @http.request(@req)['set-cookie']
    end
  end

  def request
    @req['User-Agent'] = USER_AGENT
    @req['cookie'] = cookie
    @req
  end
end

#pic_uri = 'http://www.mmkao.com/PANS/201405/5735_4.html'
#pic_uri = 'http://www.csdn.net'
#grub = Grub.new pic_uri
#grub.get_page