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
        'SERVER_PORT' => uri.port || 80
      }

      http_parser.headers.each do |name, value|
        rack_name = name.upcase.gsub('-','_')

        if !['CONTENT_TYPE', 'CONTENT_LENGTH'].include? rack_name
          rack_name = 'HTTP_' + rack_name
        end

        rack_env[rack_name] = value
      end

      rack_env.update(
        'rack.version' => [1,4],
        'rack.url_scheme' => uri.scheme,
        'rack.input' => StringIO.new(""),
        'rack.errors' => $stderr,
        'rack.multithread' => true,
        'rack.multiprocess' => true,
        'rack.run_once' => false
      )

      rack_env
    end
  end
end
