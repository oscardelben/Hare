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
      begin
        # TODO: this needs to be a loop so that we can receive data in
        # chunks
        @socket = socket
        data = socket.recvfrom(1024*1024)[0]
        receive_data data
      ensure
        socket.close
      end
    end

    def receive_data data
      request.add_data data

      post_receive_data
    end

    private

    def post_receive_data
      if request.finished?
        status, headers, body = app.call(request.env)

        response = Response.new(status, headers, body)

        socket.write response.text
        body.close if body.respond_to? :close
      end
    end

  end
end
