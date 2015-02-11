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
  end
end
