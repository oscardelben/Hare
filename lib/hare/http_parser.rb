module Hare
  # This is an http 1.1 parser written in pure Ruby.
  # It's slow!
  class HttpParser

    VALID_METHODS = [
      'OPTIONS', 'GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'TRACE', 'CONNECT'
    ].freeze

    attr_accessor :data

    def initialize
    end

    def parse!(data)
      @data = data
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
      # '*' | absolute_uri | abs_path | authority
    end
  end
end