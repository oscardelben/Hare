require 'spec_helper'

describe Hare::HttpParser do

  let(:parser) { Hare::HttpParser.new }

  describe 'request_line' do
    it 'returns nil when not parsed yet' do
      parser.parse! "GET http://example.com" # Missing \n
      parser.request_line.should be_nil
    end
    it 'returns the request line' do
      parser.parse! "GET http://example.com HTTP/1.1\n"
      parser.request_line.should == 'GET http://example.com HTTP/1.1'
    end
  end

  describe 'request_method' do
    %w!OPTIONS GET HEAD POST PUT DELETE TRACE CONNECT!.each do |meth|
      it "returns #{meth}" do
        parser.parse! "#{meth} http://example.com HTTP/1.1\n"
        parser.request_method.should == meth
      end
    end

    it 'returns uppercase method' do
      parser.parse! "get http://example.com HTTP/1.1\n"
      parser.request_method.should == 'GET'
    end

    it 'returns nil when invalid' do
      parser.parse! "HACK http://example.com HTTP/1.1\n"
      parser.request_method.should == nil
    end
  end

  describe 'request_uri' do
    it 'returns "*"' do
      parser.parse! "OPTIONS * HTTP/1.1\n"
      parser.request_uri.should == '*'
    end

    it 'returns the uri' do
      parser.parse! "GET http://example.com HTTP/1.1\n"
      parser.request_uri.should == 'http://example.com'
    end

  end

  describe 'headers' do
    it 'returns an empty hash when no headers are present' do
      parser.parse! "GET http://example.com HTTP/1.1\n\n"
      parser.headers.should == {}
    end

    it 'returns an empty hash when not finished parsing' do
      data = ""
      data += "GET http://example.com"
      data += "\nAccept-Charset = something"

      parser.parse! data
      parser.headers.should == {}
    end

    it 'returns an hash of headers' do
      data = ""
      data += "GET http://example.com"
      data += "\nAccept-Charset = something"
      data += "\n    From =    http://example.com  "
      data += "\n\n"

      parser.parse! data
      parser.headers['Accept-Charset'].should == 'something'
      parser.headers['From'].should == 'http://example.com'
    end

    it 'can handle multiline headers'
  end

  describe 'receiving data in chunks' do
    it 'handles data received in chunks' do
      data = ""
      data += "GET http://example.com"

      parser.parse! data
      parser.request_line.should be_nil
      parser.headers.should == {}

      data = "\nAccept-Charset = something"
      data += "\nFrom = http://example.com"
      data += "\n\n"

      parser.parse! data
      parser.request_line.should == 'GET http://example.com'
      parser.headers['Accept-Charset'].should == 'something'
      parser.headers['From'].should == 'http://example.com'
    end
  end

end
