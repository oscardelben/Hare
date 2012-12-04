module Hare
  class Response

    attr_accessor :status, :headers, :body

    def initialize status, headers, body
      @status = status.to_i
      @headers = headers
      @body = body
    end

    def text
      msg = Rack::Utils::HTTP_STATUS_CODES[status]

      response = "HTTP/1.1 #{status} #{msg}\r\n"

      headers.merge! 'Connection' => 'close'

      headers.each do |key, value|
        response += "#{key}: #{value}\r\n"
      end

      response += "\r\n"
      body.each { |body_part| response += body_part.to_s }
      response += "\n"
      response
    end
  end
end
