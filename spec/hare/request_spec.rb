require 'spec_helper'

describe Hare::Request do

  describe 'finished?' do
    it 'returns true if headers and body have been received' do
      request = Hare::Request.new
      data = ""
      data += "POST http://example.com"
      data += "\r\nsome:header\r\n\r\n"

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
      data += "\r\nsome:header\r\n\r\n"

      request.add_data data
      request.env['REQUEST_METHOD'].should == 'POST'
    end

    it 'should include an empty SCRIPT_NAME' do
      data = ""
      data += "GET http://example.com/?foo=bar"
      data += "\r\nsome:header\r\n\r\n"

      request.add_data data
      request.env['SCRIPT_NAME'].should == ''
    end

    describe 'PATH_INFO' do
      it 'should be equal to / by default' do
        data = ""
        data += "GET http://example.com/?foo=bar"
        data += "\r\nsome:header\r\n\r\n"

        request.add_data data
        request.env['PATH_INFO'].should == '/'
      end

      it 'should be equal to the path' do
        data = ""
        data += "GET http://example.com/some/path.html?foo=bar"
        data += "\r\nsome:header\r\n\r\n"

        request.add_data data
        request.env['PATH_INFO'].should == '/some/path.html'
      end
    end

    describe 'QUERY_STRING' do
      it 'should return the query part' do
        data = ""
        data += "GET http://example.com/?foo=bar&one=two"
        data += "\r\nsome:header\r\n\r\n"

        request.add_data data
        request.env['QUERY_STRING'].should == 'foo=bar&one=two'
      end

      it 'should return an empty string when not present' do
        data = ""
        data += "GET http://example.com/?"
        data += "\r\nsome:header\r\n\r\n"

        request.add_data data
        request.env['QUERY_STRING'].should == ''
      end
    end

    describe 'SERVER_NAME' do
      it 'should be equal to the server name' do
        data = ""
        data += "GET http://example.com/?"
        data += "\r\nsome:header\r\n\r\n"

        request.add_data data
        request.env['SERVER_NAME'].should == 'example.com'
      end
    end

    describe 'SERVER_PORT' do
      it 'should be equal to 80 by defaul' do
        data = ""
        data += "GET http://example.com/?"
        data += "\r\nsome:header\r\n\r\n"

        request.add_data data
        request.env['SERVER_PORT'].should == 80
      end

      it 'should be equal to the provided port' do
        data = ""
        data += "GET http://example.com:1234/?"
        data += "\r\nsome:header\r\n\r\n"

        request.add_data data
        request.env['SERVER_PORT'].should == 1234
      end
    end

    it 'should include HTTP_ variables' do
      data = ""
      data += "GET http://example.com:1234/?"
      data += "\r\nUser-Agent:My agent"
      data += "\r\nContent-Type:text/html"
      data += "\r\nContent-Length:0"
      data += "\r\nAuthorization:None\r\n\r\n"

      request.add_data data
      request.env['HTTP_USER_AGENT'].should == 'My agent'
      request.env['CONTENT_TYPE'].should == 'text/html'
      request.env['HTTP_CONTENT_TYPE'].should be_nil
      request.env['CONTENT_LENGTH'].should == '0'
      request.env['HTTP_CONTENT_LENGTH'].should be_nil
      request.env['HTTP_AUTHORIZATION'].should == 'None'
    end


    it 'should include rack specific variables' do
      data = ""
      data += "GET http://example.com:1234/?"
      data += "\r\nContent-Length : 5"
      data += "\r\n\r\n"
      data += "12345"

      request.add_data data
      request.env['rack.version'].should == [1,4]
      request.env['rack.url_scheme'].should == 'http'
      request.env['rack.input'].read.should == "12345"
      request.env['rack.errors'].should_not be_nil
      request.env['rack.multithread'].should == false
      request.env['rack.multiprocess'].should == false
      request.env['rack.run_once'].should == false
    end

    # TODO: make sure this behaves correctly and all fields are what
    # they should be
    it 'should include required fields with relative urls' do
      data = ""
      data += "GET /"
      data += "\r\nsome:header\r\n\r\n"

      request.add_data data
      request.env['SERVER_PORT'].should == 80
    end
  end
end
