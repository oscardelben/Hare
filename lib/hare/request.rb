require 'uri'

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
      uri = URI(http_parser.request_uri)
      rack_env = {
        'REQUEST_METHOD' => http_parser.request_method,
        'SCRIPT_NAME' => '',
        'PATH_INFO' => uri.path,
        'QUERY_STRING' => uri.query,
        'SERVER_NAME' => uri.hostname,
        'SERVER_PORT' => uri.port.to_s || '80'
      }

      http_parser.headers.each do |name, value|
        rack_name = 'HTTP_' + name.upcase.tr('-','_') # TODO: Should I handle other characters?
        rack_env[rack_name] = value
      end

      rack_env
    end
  end
end
