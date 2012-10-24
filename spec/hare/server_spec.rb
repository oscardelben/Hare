require 'spec_helper'

describe Hare::Server do

  before do
    app = lambda { |env| [200, {}, ["Hello World!"]] }

    @server = Hare::Server.new app

    @host = 'localhost'
    @port = 1234

    @options = {
      :Host => @host,
      :Port => @port
    }

    @server.run @options
  end

  it 'should return the correct response' do
    socket = TCPSocket.new @host, @port
    socket << "PUT / HTTP/1.0\r\nContent-Length: 5\r\n\r\nhello"

    socket.read.should == "HTTP/1.1 200 OK\r\n\r\nHello World!\n"
  end
end
