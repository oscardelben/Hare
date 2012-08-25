class Parser

  def initialize payload
    @payload = payload
  end

  def headers
    @payload.gsub(/\n\s+/, '').split "\n"
  end
end
