
require 'rack'

require File.join(File.dirname(__FILE__) + '/lib/hare')

class MyApp

  def call(env)
    p env
    [200, {}, ["Hello World!"]]
  end
end

# Rack::Handler::Hare.run MyApp.new
Rack::Handler::Thin.run MyApp.new
