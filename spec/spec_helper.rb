$:.push File.join(File.dirname(__FILE__), '../lib')

require 'hare'

def sample_http_request
  <<-EOL
POST /enlighten/calais.asmx HTTP/1.1
Host: myhost.com
Content-Type: text/xml; charset=utf-8

EOL
end


