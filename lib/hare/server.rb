require 'socket'

module Hare
  class Server

    # This class is used to instantiate and run the server. Because Hare
    # is a Rack server, you'll need to pass a Rack app to use it.

    attr_accessor :app

    def initialize(app)
      @app = app
    end

    def run options
      options = {
        :Host => '0.0.0.1',
        :Port => 8080
      }.merge(options)

      # The only reason why this happens inside a thread is so that we can return from this method.
      server = TCPServer.new options[:Host], options[:Port]

      Thread.new do
        loop do
          begin
            socket = server.accept
            TCPConnection.new(app).serve(socket)
          ensure
            socket.close
          end
        end
      end
    end

  end
end
