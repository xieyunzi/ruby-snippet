module Guard
  # @private api
  module Internals
    module Helpers
      def _relative_pathname(path)
        UI.debug("YUN: <_relative_pathname(path)>: #{path}")
        #port forward
        if Guard.state.session.options.listen_on
          watched_size = Guard.state.session.watchdirs.first.size
          path = path.slice((watched_size + 1)..-1)
          UI.debug("YUN: path= #{path}, pwd= #{Pathname.pwd}")
          Pathname(path)
        else
          full_path = Pathname(path)
          full_path.relative_path_from(Pathname.pwd)
        end
      rescue ArgumentError
        full_path
      end
    end
  end
end
