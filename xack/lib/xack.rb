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

      app = eval "Builder.new { #{File.read(ARGV.first)} }.to_app"
      Thin::Server.start('0.0.0.0', 3000, app)
    end
  end

  class Builder
    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def run(app)
      @run = app
    end

    def to_app
      @run
    end
  end

end
