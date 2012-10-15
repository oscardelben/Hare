require 'spec_helper'

describe Hare::HttpParser do

  let(:parser) { Hare::HttpParser.new }

  describe 'request_line' do
    it 'returns nil when not parsed yet' do
      parser.parse! "GET http://example.com" # Missing \n
      parser.request_line.should be_nil
    end
    it 'returns the request line' do
      parser.parse! "GET http://example.com HTTP/1.1\r\n"
      parser.request_line.should == 'GET http://example.com HTTP/1.1'
    end
  end

  describe 'request_method' do
    %w!OPTIONS GET HEAD POST PUT DELETE TRACE CONNECT!.each do |meth|
      it "returns #{meth}" do
        parser.parse! "#{meth} http://example.com HTTP/1.1\r\n"
        parser.request_method.should == meth
      end
    end

    it 'returns uppercase method' do
      parser.parse! "get http://example.com HTTP/1.1\r\n"
      parser.request_method.should == 'GET'
    end

    it 'returns nil when invalid' do
      parser.parse! "HACK http://example.com HTTP/1.1\r\n"
      parser.request_method.should == nil
    end
  end

  describe 'request_uri' do
    it 'returns "*"' do
      parser.parse! "OPTIONS * HTTP/1.1\r\n"
      parser.request_uri.should == '*'
    end

    it 'returns the uri' do
      parser.parse! "GET http://example.com HTTP/1.1\r\n"
      parser.request_uri.should == 'http://example.com'
    end

  end

  describe 'headers' do
    it 'returns an empty hash when no headers are present' do
      parser.parse! "GET http://example.com HTTP/1.1\r\n"
      parser.headers.should == {}
    end

    it 'returns an empty hash when not finished parsing' do
      data = ""
      data += "GET http://example.com"
      data += "\r\nAccept-Charset = something"

      parser.parse! data
      parser.headers.should == {}
    end

    it 'returns an hash of headers' do
      data = ""
      data += "GET http://example.com"
      data += "\r\nAccept-Charset = something"
      data += "\r\n    From =    http://example.com  "
      data += "\r\n\r\n"

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

      data = "\r\nAccept-Charset = something"
      data += "\r\nFrom = http://example.com"
      data += "\r\n\r\n"

      parser.parse! data
      parser.request_line.should == 'GET http://example.com'
      parser.headers['Accept-Charset'].should == 'something'
      parser.headers['From'].should == 'http://example.com'
    end
  end

  describe 'has_body?' do
    it 'returns true when Content-Length is present' do
      data = ""
      data += "GET http://example.com"

      data = "\r\nContent-Length = 123"
      data += "\r\n\r\n"

      parser.parse! data
      parser.has_body?.should be_true
    end

    it 'returns true when Transfer-Encoding is present' do
      data = ""
      data += "GET http://example.com"

      data = "\r\nTransfer-Encoding = 123"
      data += "\r\n\r\n"

      parser.parse! data
      parser.has_body?.should be_true
    end

    it 'returns false when neither Content-Length nor Transfer-Encoding are present' do
      data = ""
      data += "GET http://example.com"

      parser.parse! data
      parser.has_body?.should be_false
    end
  end

  describe 'body' do
  end

  describe 'finished?' do

    it 'returns true when headers are parsed and body is not present' do
      data = ""
      data += "GET http://example.com"

      parser.parse! data
      parser.request_line.should be_nil
      parser.headers.should == {}

      data = "\r\nAccept-Charset = something"
      data += "\r\nFrom = http://example.com"
      data += "\r\n\r\n"

      parser.parse! data
      parser.finished?.should be_true
    end

    it 'returns true when headers and body are parsed'

    it 'returns false when headers are not parsed' do
      parser.parse! "GET http://example.com"
      parser.finished?.should be_false
    end

    it 'returns false when headers are parsed but body is expected but not parsed'
  end

end
