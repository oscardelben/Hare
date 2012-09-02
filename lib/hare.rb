
$:.unshift File.dirname(__FILE__)

require 'eventmachine'

require 'hare/request'
require 'hare/server'
require 'hare/socket'

module Hare
  VERSION = "0.0.1"
end
