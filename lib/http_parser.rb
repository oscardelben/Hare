class HttpParser

  def initialize request_line, raw_headers, body
    @request_line = request_line
    @raw_headers = raw_headers
    @body = body
  end

  def headers
  end
end
