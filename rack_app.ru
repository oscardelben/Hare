
require 'rack'

require File.join(File.dirname(__FILE__) + '/lib/hare')

class MyApp

  def call(env)
    [200, {}, [""]]
  end
end

Rack::Handler::Hare.run MyApp.new
