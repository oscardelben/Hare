module Hare
  class TCPConnection

    # The role of this class is to handle the incoming data from the
    # socket connection and provide a response.

    attr_accessor :app, :request, :socket, :http_parser

    def initialize(app)
      @app = app
      @http_parser = HttpParser.new
    end

    def serve(socket)
      @socket = socket

      loop do
        until http_parser.finished?
          data = socket.recv(1024*8)
          http_parser.parse! data
        end

        build_request
        send_response

        break if http_parser.headers['Connection'] == 'close'

        http_parser.clear
      end
    end

    private

    def build_request
      @request = Request.new
      request.request_uri = http_parser.request_uri
      request.request_method = http_parser.request_method
      request.headers = http_parser.headers
      request.body = http_parser.body
    end

    def send_response
      status, headers, body = app.call(request.env)

      response = Response.new(status, headers, body)

      socket.syswrite response.text
      socket.flush
      body.close if body.respond_to? :close
    end

  end
end
