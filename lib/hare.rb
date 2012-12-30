$:.unshift File.dirname(__FILE__)

require 'rack'

require 'hare/http_parser'
require 'hare/request'
require 'hare/response'
require 'hare/server'
require 'hare/tcp_connection'

require 'rack/handler/hare'

module Hare
  VERSION = "0.0.1"
end
