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

      Socket.tcp_server_loop(options[:Host], options[:Port])  do |socket, client_addrinfo|
        SocketHandler.new(app).read_socket(socket)
      end
    end

  end
end
