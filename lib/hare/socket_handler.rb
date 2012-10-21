module Hare
  class SocketHandler

    # The role of this class is to handle the incoming data from the
    # socket connection and provide a response.

    attr_accessor :app, :request, :socket

    def initialize(app)
      @app = app
      @request = Request.new
    end

    def read_socket(socket)
      @socket = socket

      begin
        until request.finished?
          data = socket.recvfrom(1024*1024)[0]
          request.add_data data
        end

        send_response
      ensure
        socket.close
      end
    end

    private

    def send_response
      status, headers, body = app.call(request.env)

      response = Response.new(status, headers, body)

      socket.write response.text
      body.close if body.respond_to? :close
    end

  end
end
