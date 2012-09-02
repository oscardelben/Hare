
$:.unshift File.dirname(__FILE__)

require 'eventmachine'

require 'hare/http_parser'
require 'hare/server'
require 'hare/socket'

module Hare
  VERSION = "0.0.1"
end
