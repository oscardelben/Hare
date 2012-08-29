
$:.unshift File.dirname(__FILE__)

require 'rack/handler/hare'

require 'hare/http_parser'
require 'hare/server'

module Hare
  VERSION = "0.0.1"
end
