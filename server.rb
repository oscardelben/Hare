# Example server
#
# ruby -I lib server.rb

require 'socket'
require 'http_parser'
require 'eventmachine'

class Server < EM::Connection
  def post_init
    puts "New connection received."
    @http_parser = HttpParser.new
  end

  def receive_data data
    @http_parser.add_data data

    # TODO: this has to be changed.
    close_connection if @http_parser.all_data_received?
  end

  def unbind
    puts "Client disconnected."
  end
end

EM.run {
  EM.start_server "127.0.0.1", 8080, Server
}
