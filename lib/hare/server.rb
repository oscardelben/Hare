require 'socket'

module Hare
  class Server

    # This class is used to instantiate and run the server. Because Hare
    # is a Rack server, you'll need to pass a Rack app to use it.

    attr_accessor :app, :server

    def initialize app
      @app = app
    end

    def run options
      options = {
        :Host => '0.0.0.0',
        :Port => 8080
      }.merge options

      @server = TCPServer.new options[:Host], options[:Port]

      if options[:background]
        Thread.new { start_server_loop }
      else
        start_server_loop
      end
    end

    private

    def start_server_loop
      loop do
        begin
          socket = server.accept
          TCPConnection.new(app).serve socket
        ensure
          socket.close
        end
      end
    end
  end
end
