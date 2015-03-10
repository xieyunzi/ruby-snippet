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

    def initialize(default_app = nil, &block)
      @use, @map, @run = [], nil, default_app
      instance_eval(&block) if block_given?
    end

    def run(app)
      @run = app
    end

    def to_app
      app = @map ? generate_map(@run, @map) : @run
      @use.empty? ? app : @use.reverse.inject(app) { |run, u| u.shift.new(run, *u) }
    end

    def use(middle, *args)
      @use ||= []
      @use << [middle, *args]
    end

    def map(path, &block)
      @map ||= {}
      @map[path] = block
    end

    private
    def generate_map(default_app, mapping)
      mapped = default_app ? { '/' => default_app } : {}
      mapping.each { |p, b| mapped[p] = self.class.new(default_app, &b).to_app }
      URLMap.new(mapped)
    end
  end

  class URLMap
    def initialize(map = {})
      @mapping = map
    end

    def call(env)
      path = env['PATH_INFO']

      @mapping.each do |location, app|
        LOGGER.info({
          script_name: env['SCRIPT_NAME'],
          path_info: path,
          location: location,
          app: app.inspect
        })
        LOGGER.info(path == location)

        return app.call(env) if path == location
      end

      LOGGER.info("path #{__LINE__}")
      [404, { 'Content-Type' => 'text/plain', 'X-Cascade' => 'pass' }, [ "Not Found: #{path}"]]
    end
  end

end
