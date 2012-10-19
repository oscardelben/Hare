module Hare
  class Socket < EventMachine::Connection

    # The role of this class is to handle the incoming data from the
    # socket connection and provide a response.

    attr_accessor :app, :request

    def post_init
      @request = Request.new
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

        close_connection_after_writing
      end
    end

  end
end
