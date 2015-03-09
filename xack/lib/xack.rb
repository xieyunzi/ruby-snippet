require 'logger'
require 'thin'

module Xack
  class Server
    LOGGER = Logger.new(STDOUT)

    class << self
      def start
        new.start
      end
    end

    def initialize
    end

    def start
      LOGGER.info('start')
      LOGGER.info(ARGV.first)
      LOGGER.info(File.read(ARGV.first))

      app = -> { [200, { 'Content-Type' => 'text/html' }, ['Hello world!']] }
      Thin::Server.start('0.0.0.0', 3000, app)
    end
  end
end
