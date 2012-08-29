require 'helper'

class TestSocket < MiniTest::Unit::TestCase

  def setup
    @em = Minitest::Mock.new
    @socket = Hare::Socket.new(@em)

    # Poor man stubbing, good for now.
    def @socket.close_connection; nil; end

    @socket.post_init
  end

  def test_all_data_received_when_all_data
    data = "GET / HTTP/1.1\r\nHost: localhost:8080\r\nAccept: */*\r\n\r\n"

    @socket.receive_data data
    assert @socket.all_data_received?
  end

  def test_all_data_received_when_all_data_in_chunks
    data = "GET / HTTP/1.1\r\nHost: localhost"

    @socket.receive_data data

    refute @socket.all_data_received?

    data = ":8080\r\nAccept: */*\r\n\r\n"
    @socket.receive_data data

    assert @socket.all_data_received?
  end
end

