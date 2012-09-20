module Hare
  # This is an http 1.1 parser written in pure Ruby.
  # It's probably slow!
  #
  # Limitations:
  #  * Can't handle multiline headers
  #  * doesn't parse body yet
  class HttpParser

    VALID_METHODS = [
      'OPTIONS', 'GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'TRACE', 'CONNECT'
    ].freeze

    attr_accessor :data

    def initialize
      @data = ""
    end

    # TODO: investigate if we can leverage some io class for incoming
    # data
    # TODO: make sure we don't store tooooo much data
    def parse!(data)
      @data << data
    end

    def request_line
      data.split("\n").first if data.include? "\n"
    end

    def request_method
      if request_line
        m = request_line.split.first
        m && m.upcase!
        m if VALID_METHODS.include? m
      end
    end

    def request_uri
      if request_line
        request_line.split[1]
      end
    end

    # Returns a hash of headers
    def headers
      request_data = data.split("\n\n").first if data.include? "\n\n"

      if request_data
        parse_headers(request_data)
      else
        {}
      end
    end

    def has_body?
      headers['Content-Length'] || headers['Transfer-Encoding']
    end

    # Returns true if headers and body are parsed (if needed)
    # TODO: we don't parse the body yet
    def finished?
      headers.any?
    end

    private

    def parse_headers(headers_data)
      headers = {}
      # Ignore first line (request_line)
      headers_data.split("\n")[1..-1].each do |line|
        key, value = line.split('=').map(&:strip)
        headers[key] = value
      end
      headers
    end
  end
end
