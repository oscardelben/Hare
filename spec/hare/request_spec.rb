require 'spec_helper'

describe Hare::Request do

  describe 'add_data' do
    # TODO: test that calling add_data multiple times will populate all
    # headers, etc
    it 'continuosly parse data'
  end

  describe 'finished?' do
    it 'returns true if headers and body have been received' do
      pending 'missing implementation'
      request = Hare::Request.new
      request.add_data sample_http_request
      request.should be_finished
    end

    it 'returns false if headers and body have not been received' do
      request = Hare::Request.new
      request.should_not be_finished
    end
  end
end
