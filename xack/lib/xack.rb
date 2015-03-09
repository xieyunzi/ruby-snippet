require 'logger'
require 'thin'

module Xack
  LOGGER = Logger.new(STDOUT)

  class Server
    class << self
      def start
        new.start
      end
    end

    def initialize
    end

    def start
      config = ARGV.first

      app = Builder.parse_file(config)
      Thin::Server.start('0.0.0.0', 3000, app)
    end
  end

  class Builder
    class << self
      def parse_file(config)
        LOGGER.info(config)

        builder_script = File.read(config)
        new_from_string(builder_script)
      end

      def new_from_string(builder_script)
        LOGGER.info(builder_script)

        eval "Builder.new { #{builder_script} }.to_app"
      end
    end

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
