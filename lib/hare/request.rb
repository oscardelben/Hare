module Hare
  class Request

    # This method is called by Socket to append data
    def add_data(data)
    end

    # Returns true if headers and body have been received, otherwise
    # false.
    def finished?
      false
    end
  end
end
