require 'helper'

class TestHttpParser < MiniTest::Unit::TestCase

  def setup
    @http_parser = HttpParser.new
  end

  def test_all_data_received_when_all_data
    data = "GET / HTTP/1.1\r\nHost: localhost:8080\r\nAccept: */*\r\n\r\n"

    @http_parser.add_data data
    assert @http_parser.all_data_received?
  end

  def test_all_data_received_when_all_data_in_chunks
    data = "GET / HTTP/1.1\r\nHost: localhost"
    @http_parser.add_data data

    refute @http_parser.all_data_received?

    data = ":8080\r\nAccept: */*\r\n\r\n"
    @http_parser.add_data data

    assert @http_parser.all_data_received?
  end
end

