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

    # This undocumented callback gets called by #start_server every time
    # a connection is received, passing the handler object (an instance
    # of +Socket+ in this case).
    #
    # We use this callback to pass the +app+ object to the socket.
    def initialize_socket(socket)
      socket.app = app
    end

  end
end
