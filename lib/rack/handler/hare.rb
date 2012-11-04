module Rack
  module Handler
    module Hare

      def self.run(app, options={})
        # TODO: handle options from Rack

        server = ::Hare::Server.new(app)
        server.run options
      end
    end

    register :hare, Hare
  end
end
