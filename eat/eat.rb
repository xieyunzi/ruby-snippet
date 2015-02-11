require 'open-uri'
require 'nokogiri'
require 'forwardable'

module Eat
  class Page
    attr_reader :url, :depth, :status, :headers, :body, :response_time, :redirect_to

    def initialize(uri, params = {})
      @uri = uri
      @url = uri.to_s

      @depth = params[:depth] || 0

      @status = params[:status]
      @headers = params[:headers]
      @body = params[:body]
      @response_time = params[:response_time]
      @redirect_to = params[:redirect_to]
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
      when /^\/[^\/]*/
        root + path.to_s
      # relative path
      when /^[^(\/)|(http)]/
        # auther scheme
        if (HTTP.uri(path).absolute? rescue true)
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

    def_delegators :@storage, :[], :[]=, :has_key?, :each

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
      @urls = [urls].flatten.map { |url| HTTP.uri(url) }
      @urls.each { |url| url.path = '/' if url.path.empty? }

      @opts = opts
      @pages = PageStore.new
    end

    def run
      page_queue = []
      link_queue = []

      @urls.each { |url| link_queue.push HTTP.uri(url) }

      http = HTTP.new

      loop do
        puts "link_queue.size: #{link_queue.size}, page_queue.size: #{page_queue.size}" if @opts[:verbose]

        while lq = link_queue.pop
          uri, referer, depth = lq

          puts "link: [uri: #{uri.to_s}, referer: #{referer}, depth: #{depth}]" if @opts[:verbose]

          page = http.fetch_page(uri, referer, depth)
          page_queue.push page

          puts "fetch_page: #{page.url}" if @opts[:verbose]
        end

        page = page_queue.pop
        @pages[page.url] = page

        links = page.links.select { |link| visit_link?(link, page) }
        links.each do |link|
          link_queue << [HTTP.uri(link), page.url, page.depth + 1]
        end

        break if page_queue.empty? && link_queue.empty?
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

require 'faraday'

module Eat
  class HTTP
    def initialize
      @connections = {}
    end

    def connection(uri)
      @connections[uri.host] ||= {}
      @connections[uri.host][uri.port] = Faraday.new(url: uri.to_s)
    end

    def fetch_page(uri, referer = nil, depth = nil)
      page = nil
      get_response(uri) do |response, loc, redirect_to, response_time|
        page = Page.new(loc, referer: referer,
                             depth: depth,
                             status: response.status,
                             headers: response.headers,
                             body: response.body,
                             redirect_to: redirect_to,
                             response_time: response_time)
      end
      return page
    end

    def self.uri(url)
      url.is_a?(URI) ? url : URI.parse(URI.encode(url))
    end

    private
    def get_response(uri, referer = nil)
      host = uri.host
      begin
        start = Time.now

        uri.host = host unless uri.host
        response = connection(uri).get

        finish = Time.now
        response_time = ((finish - start) * 1000).round

        redirect_to = redirect(response.status) ? HTTP.uri(response.headers[:location]) : nil
        yield response, uri, redirect_to, response_time
      end while uri = redirect_to
    end

    def redirect(status)
      (300..399).include? status
    end
  end
end
