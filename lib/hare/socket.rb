module Hare
  class Socket < EventMachine::Connection

    # The role of this class is to handle the incoming data from the
    # socket connection.

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
        send_data response.data

        close_connection
      end
    end

  end
end
