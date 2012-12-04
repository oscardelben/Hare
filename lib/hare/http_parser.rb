module Hare
  # This is an http 1.1 parser written in pure Ruby.
  # It's probably slow!
  #
  # Limitations:
  #  * Can't handle multiline headers
  class HttpParser

    VALID_METHODS = [
      'OPTIONS', 'GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'TRACE', 'CONNECT'
    ].freeze

    CRLF = /\r\n/.freeze
    CRLFCRLF = /\r\n\r\n/.freeze

    MAX_BODY_LENGTH = (1024 * 1024).to_i # 1 MB

    attr_accessor :data, :headers

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
      data.split(CRLF, 2).first if data =~ CRLF
    end

    def request_method
      if request_line
        m = request_line.split(' ').first
        m && m.upcase!
        m if VALID_METHODS.include? m
      end
    end

    def request_uri
      if request_line
        request_line.split(' ')[1]
      end
    end

    # Returns a hash of headers
    def headers
      return @headers if @headers

      request_data = data.split(CRLFCRLF).first if data =~ CRLFCRLF

      if request_data
        @headers = parse_headers(request_data)
      end
    end

    def has_body?
      headers && (headers['Content-Length'] || headers['Transfer-Encoding'])
    end

    # A request is parsed when headers and body (if necessary) are
    # parsed.
    def finished?
      if headers
        if has_body?
          body && body.length == headers['Content-Length'].to_i
        else
          true
        end
      else
        false
      end
    end

    def body
      # TODO: it may be highly inefficient to split large data
      # TODO: handle length
      if has_body?
        body = data.split(CRLFCRLF, 2).last if data =~ CRLFCRLF
        length = headers['Content-Length'].to_i - 1
        body[0..length]
      end
    end

    private

    def parse_headers(headers_data)
      headers = {}
      # Ignore first line (request_line)
      headers_data.split(CRLF)[1..-1].each do |line|
        key, value = line.split(':', 2).map(&:strip)
        headers[key] = value
      end
      headers
    end
  end
end
