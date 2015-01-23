require 'open-uri'
require 'nokogiri'
require 'forwardable'

module Eat
  class Page
    attr_reader :url, :depth

    def initialize(url, params = {})
      @url = url
      @uri = URI(@url)

      @depth = params[:depth] || 0

      body
    end

    def links
      doc.css('a[href]').inject([]) do |links, a|
        path = absolute_url(a['href'])
        path ? (links << path) : links
      end
    end

    def images
      doc.css('img').inject([]) do |links, a|
        path = absolute_url(a['data-fullsrc']) || absolute_url(a['data-src']) || absolute_url(a['src'])
        path ? (links << path) : links
      end
    end

    def doc
      @doc ||= Nokogiri::HTML(body)
    end

    def body
      @body ||= open(@url)
    end

    def root
      @root ||= @uri.scheme + '://' + @uri.host
    end

    private

    def absolute_url(path)
      case path
      # javascript: void(0)
      when /javascript/
        nil
      # absolute path
      when /^\/[^\/]/
        root + path.to_s
      # relative path
      when /^[^(\/)|(http)]/
        # auther scheme
        if (URI(path).absolute? rescue true)
          #{scheme: URI(path).scheme, path: path}
          nil
        else
          root + @uri.path + path.to_s
        end
      else
        path
      end
    end
  end
end


module Eat
  class PageStore
    extend Forwardable

    def_delegators :@storage, :[], :[]=, :has_key?

    def initialize
      @storage = Hash.new
    end

  end
end

module Eat
  class Core
    attr_reader :urls, :pages

    # @params urls, Array or String
    # @params opts, Hash, :depth_limit
    def initialize(urls, opts={})
      @urls = [urls].flatten.map { |url| url.is_a?(URI) ? url : URI(url) }
      @urls.each { |url| url.path = '/' if url.path.empty? }

      @opts = opts
      @pages = PageStore.new
    end

    def run
      page_queue = []
      link_queue = []

      @urls.each { |url| link_queue.push url }

      loop do
        puts "link_queue.size: #{link_queue.size}, page_queue.size: #{page_queue.size}" if @opts[:verbose]

        while lq = link_queue.pop
          url, referer, depth = lq
          page = fetch_page(url, referer, depth)
          page_queue.push page

          puts "fetch_page: #{page.url}" if @opts[:verbose]
        end

        page = page_queue.pop
        @pages[page.url] = page

        links = page.links.select { |link| visit_link?(link, page) }
        links.each do |link|
          link_queue << [link, page.url, page.depth]
        end

        break if page_queue.empty? && link_queue.empty?
      end
    end

    def fetch_page(url, referer = nil, depth = nil)
      Page.new(url, referer: referer, depth: depth)
    end

    def fetch_pages(urls, referer = nil, depth = nil)
      urls.inject({}) do |h, url|
        h[url] = fetch_page(url, referer, depth)
        h
      end
    end

    private

    def visit_link?(link, from_page)
      !@pages.has_key?(link) && !too_deep?(from_page)
    end

    def too_deep?(from_page)
      if from_page.depth && @opts[:depth_limit]
        from_page.depth >= @opts[:depth_limit]
      else
        flase
      end
    end
  end
end
