require 'minitest/autorun'
require './eat'

module Eat
  class TestPage < MiniTest::Test
    class Eat::Page
      def body
        open('./oschina.net.txt')
      end
    end

    def setup
      @page = Page.new('http://www.oschina.net', depth: 1)
    end

    def test_links
      assert @page.links.is_a?(Array)
    end

    def test_images
      assert @page.images.is_a?(Array)
    end
  end

  class TestPageStore < MiniTest::Test
    def setup
      @store = PageStore.new
    end

    def test_has_key?
      @store['ok'] = 'ok'
      assert @store.has_key? 'ok'
    end
  end

  class TestCore < MiniTest::Test
    def setup
      @core = Core.new('http://www.oschina.net', depth_limit: 1)
    end

    def test_fetch_page
      url = @core.urls.first
      page = @core.fetch_page(url, nil, 1)
      assert_equal page.url.to_s, url.to_s
    end
  end
end
