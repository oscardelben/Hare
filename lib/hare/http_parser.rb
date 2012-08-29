require 'eventmachine'

module Hare
  class HttpParser

    # The role of this class is to determine wherever the server has
    # enough data, and deal with it.

    attr_accessor :data

    def initialize
      @data = ""
    end

    def add_data data
      @data << data
    end

    def all_data_received?
      # Check that at least request line and the headers have been
      # received.
      # TODO: check for body presence when necessary
      data.split("\n").size > 1 && data.end_with?("\n")
    end
  end
end
