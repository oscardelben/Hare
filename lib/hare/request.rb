# A Request object!
module Hare
  class Request

    attr_accessor :http_parser

    def initialize
      @http_parser = HttpParser.new
    end

    # This method is called by Socket to append data
    def add_data(data)
      @http_parser.parse! data
    end

    # Returns true if headers and body have been received, otherwise
    # false.
    def finished?
      http_parser.finished?
    end

    def env
      {
        'REQUEST_METHOD' => http_parser.request_method,
        'SCRIPT_NAME' => ''
      }
    end
  end
end
