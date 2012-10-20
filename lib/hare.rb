$:.unshift File.dirname(__FILE__)

require 'eventmachine'
require 'rack'

require 'hare/http_parser'
require 'hare/request'
require 'hare/response'
require 'hare/server'
require 'hare/socket'

require 'rack/handler/hare'

module Hare
  VERSION = "0.0.1"
end
