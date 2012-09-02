require 'spec_helper'

describe Hare::Request do

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
