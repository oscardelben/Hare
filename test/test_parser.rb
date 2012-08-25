require 'helper'

class TestParser < MiniTest::Unit::TestCase

  def test_multiline_headers
    payload = "foo=bar\nsome thing=else\n\n\n"

    # TODO: verify that headers can contain spaces in their name
    headers = ['foo=bar', 'some thing=else']

    assert_equal headers, Parser.new(payload).headers
  end

  def test_multiline_folding
    payload = "foo=bar\n\n\t   test"

    headers = ['foo=bartest']

    assert_equal headers, Parser.new(payload).headers
  end

end

