require 'spec_helper'

describe Hare::Response do

  it 'should contain a status code' do
    response = Hare::Response.new 200, {}, [""]
    response.text.should start_with "HTTP/1.1 200 OK"
  end

  it 'should include headers' do
    headers = {
      'Content-Type' => 'text/html',
      'Length' => '1234 45'
    }
    response = Hare::Response.new 200, headers, [""]
    response.text.should include 'Content-Type: text/html'
    response.text.should include 'Length: 1234 45'
  end

  it 'should include a body' do
    response = Hare::Response.new 200, {}, ["foo"]
    response.text.should end_with "foo\n"
  end

  it 'should be well formatted' do
    headers = {
      'Content-Type' => 'text/html',
      'Length' => '1234 45'
    }
    response = Hare::Response.new 200, headers, ["hello world"]

    expected = "HTTP/1.1 200 OK\r\n"
    expected += "Content-Type: text/html\r\n"
    expected += "Length: 1234 45\r\n"
    expected += "Connection: close\r\n\r\n"
    expected += "hello world\n"

    response.text.should == expected
  end

  it 'should include connection header' do
    response = Hare::Response.new 200, {}, [""]
    response.text.should include 'Connection: close'
  end
end

