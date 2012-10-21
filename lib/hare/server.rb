require 'socket'

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
      Socket.tcp_server_loop('127.0.0.1', 8080)  do |socket, client_addrinfo|
        SocketHandler.new(app).read_socket(socket)
      end
    end

  end
end
