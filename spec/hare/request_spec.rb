require 'spec_helper'

describe Hare::Request do

  describe 'env' do

    def build_request(attributes={})
      request = Hare::Request.new

      attributes = {
        :request_uri => 'http://example.com',
        :request_method => 'get',
        :headers => {},
        :body => nil
      }.merge(attributes)

      request.request_uri = attributes[:request_uri]
      request.request_method = attributes[:request_method]
      request.headers = attributes[:headers]
      request.body = attributes[:body]

      request
    end

    it 'should include REQUEST_METHOD' do
      request = build_request :request_method => 'POST'

      request.env['REQUEST_METHOD'].should == 'POST'
    end

    it 'should include an empty SCRIPT_NAME' do
      request = build_request

      request.env['SCRIPT_NAME'].should == ''
    end

    describe 'PATH_INFO' do
      it 'should be empty by default' do
        request = build_request

        request.env['PATH_INFO'].should == ''
      end

      it 'should be equal to the path' do
        request = build_request :request_uri => "http://example.com/some/path.html?foo=bar"

        request.env['PATH_INFO'].should == '/some/path.html'
      end
    end

    describe 'QUERY_STRING' do
      it 'should return the query part' do
        request = build_request :request_uri => "http://example.com/?foo=bar&one=two"

        request.env['QUERY_STRING'].should == 'foo=bar&one=two'
      end

      it 'should return an empty string when not present' do
        request = build_request

        request.env['QUERY_STRING'].should == ''
      end
    end

    describe 'SERVER_NAME' do
      it 'should be equal to the server name' do
        request = build_request

        request.env['SERVER_NAME'].should == 'example.com'
      end
    end

    describe 'SERVER_PORT' do
      it 'should be equal to 80 by defaul' do
        request = build_request

        request.env['SERVER_PORT'].should == 80
      end

      it 'should be equal to the provided port' do
        request = build_request :request_uri => "http://example.com:1234"
        request.env['SERVER_PORT'].should == 1234
      end
    end

    it 'should include HTTP_ variables' do
      headers = {
        'User-Agent' => 'My agent',
        'Content-Type' => 'text/html',
        'Content-Length' => '0',
        'Authorization' => 'None'
      }
      request = build_request :headers => headers

      request.env['HTTP_USER_AGENT'].should == 'My agent'
      request.env['CONTENT_TYPE'].should == 'text/html'
      request.env['HTTP_CONTENT_TYPE'].should be_nil
      request.env['CONTENT_LENGTH'].should == '0'
      request.env['HTTP_CONTENT_LENGTH'].should be_nil
      request.env['HTTP_AUTHORIZATION'].should == 'None'
    end


    it 'should include rack specific variables' do
      request = build_request :body => '12345'

      request.env['rack.version'].should == [1,4]
      request.env['rack.url_scheme'].should == 'http'
      request.env['rack.input'].read.should == "12345"
      request.env['rack.errors'].should_not be_nil
      request.env['rack.multithread'].should == false
      request.env['rack.multiprocess'].should == false
      request.env['rack.run_once'].should == false
    end
  end
end
