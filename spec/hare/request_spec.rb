require 'spec_helper'

describe Hare::Request do

  describe 'finished?' do
    it 'returns true if headers and body have been received' do
      request = Hare::Request.new
      data = ""
      data += "POST http://example.com"
      data += "\r\nsome=header\r\n\r\n"

      request.add_data data
      request.should be_finished
    end

    it 'returns false if headers and body have not been received' do
      request = Hare::Request.new
      request.should_not be_finished
    end
  end

  describe 'env' do
    let (:request) { Hare::Request.new }

    it 'should include REQUEST_METHOD' do
      data = ""
      data += "POST http://example.com"
      data += "\r\nsome=header\r\n"

      request.add_data data
      request.env['REQUEST_METHOD'].should == 'POST'
    end

    it 'should include an empty SCRIPT_NAME' do
      data = ""
      data += "GET http://example.com/?foo=bar"
      data += "\r\nsome=header\r\n"

      request.add_data data
      request.env['SCRIPT_NAME'].should == ''
    end

    describe 'PATH_INFO' do
      it 'should be equal to / by default' do
        data = ""
        data += "GET http://example.com/?foo=bar"
        data += "\r\nsome=header\r\n"

        request.add_data data
        request.env['PATH_INFO'].should == '/'
      end

      it 'should be equal to the path' do
        data = ""
        data += "GET http://example.com/some/path.html?foo=bar"
        data += "\r\nsome=header\r\n"

        request.add_data data
        request.env['PATH_INFO'].should == '/some/path.html'
      end
    end

    describe 'QUERY_STRING' do
      it 'should return the query part' do
        data = ""
        data += "GET http://example.com/?foo=bar&one=two#baz"
        data += "\r\nsome=header\r\n"

        request.add_data data
        request.env['QUERY_STRING'].should == 'foo=bar&one=two'
      end

      it 'should return an empty string when not present' do
        data = ""
        data += "GET http://example.com/?#baz"
        data += "\r\nsome=header\r\n"

        request.add_data data
        request.env['QUERY_STRING'].should == ''
      end
    end

    describe 'SERVER_NAME' do
      it 'should be equal to the server name' do
        data = ""
        data += "GET http://example.com/?#baz"
        data += "\r\nsome=header\r\n"

        request.add_data data
        request.env['SERVER_NAME'].should == 'example.com'
      end
    end
  end
end
