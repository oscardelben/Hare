module Hare
  class Socket < EventMachine::Connection

    # The role of this class is to handle the incoming data from the
    # connection.

    attr_accessor :data, :server

    def post_init
      @data = ""
    end

    def receive_data data
      @data << data

      close_connection if all_data_received?
    end

    def all_data_received?
      # Check that at least request line and the headers have been
      # received.
      # TODO: check for body presence when necessary
      data.split("\n").size > 1 && data.end_with?("\n")
    end
  end
end
