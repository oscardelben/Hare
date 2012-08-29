
module Hare
  class Server

    # This class is used to instantiate and run the server. Because Hare
    # is a Rack server, you'll need to pass a Rack app to use it.

    attr_accessor :app

    def initialize(app)
      @app = app
    end

    def run
      # TODO: make sure it's not running already?
      EM.run do
        puts "Starting Hare server..."
        EM.start_server "127.0.0.1", 8080, Socket, &method(:initialize_socket)
        puts "Server started at 127.0.0.1:8080"
      end
    end

    def initialize_socket(socket)
      socket.server = self
    end

  end
end
