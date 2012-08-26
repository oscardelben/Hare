# Example server
#
# ruby -I lib server.rb

require 'socket'
require 'http_parser'

server = TCPServer.new '127.0.0.1', '8080'

while socket = server.accept
  puts "Connection received."
  begin
    request_line = socket.gets

    raw_headers = ""
    add_newline = false
    while (line = socket.gets) !~ /^\s+$/ # CRLF
      raw_headers << "\n" if add_newline
      raw_headers << line
      add_newline = true
    end

    # Body is signaled by either Content-Length or Transfer-Encoding
    body = nil
    if false # not implemented yet
      body = socket.gets
    end

    p request_line
    p raw_headers
    p body

    HttpParser.new request_line, raw_headers, body

    # TODO: make sure you timeout the client if you don't get
    # everything

    socket.puts "Hello, world!"

  ensure
    socket.close
  end
end
