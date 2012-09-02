require 'spec_helper'

describe Hare::HttpParser do

  let(:parser) { Hare::HttpParser.new }

  describe 'request_line' do
    it 'returns nil when not parsed yet' do
      parser.parse! "GET http://example.com" # Missing \n
      parser.request_line.should be_nil
    end
    it 'returns the request line' do
      parser.parse! "GET http://example.com\n"
      parser.request_line.should == 'GET http://example.com'
    end
  end

  describe 'request_method' do
    %w!OPTIONS GET HEAD POST PUT DELETE TRACE CONNECT!.each do |meth|
      it "returns #{meth}" do
        parser.parse! "#{meth} http://example.com\n"
        parser.request_method.should == meth
      end
    end

    it 'returns uppercase method' do
      parser.parse! "get http://example.com\n"
      parser.request_method.should == 'GET'
    end

    it 'returns nil when invalid' do
      parser.parse! "HACK http://example.com\n"
      parser.request_method.should == nil
    end
  end

  describe 'request_uri' do
  end

end
