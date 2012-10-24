require 'uri'

# A Request object!
module Hare
  class Request

    attr_accessor :request_uri, :request_method, :headers, :body

    def env
      uri = URI(request_uri)

      rack_env = {
        'REQUEST_METHOD' => request_method,
        'SCRIPT_NAME' => '',
        'PATH_INFO' => uri.path,
        'QUERY_STRING' => uri.query.to_s,
        'SERVER_NAME' => uri.hostname,
        'SERVER_PORT' => uri.port || 80
      }

      headers.each do |name, value|
        name = name.upcase.gsub('-','_') # converts Content-Type to CONTENT_TYPE

        if !['CONTENT_TYPE', 'CONTENT_LENGTH'].include? name
          name = 'HTTP_' + name # append HTTP_ when needed
        end

        rack_env[name] = value
      end

      rack_env.update(
        'rack.version' => [1,4],
        'rack.url_scheme' => uri.scheme,
        'rack.input' => StringIO.new(body.to_s),
        'rack.errors' => $stderr,
        'rack.multithread' => false,
        'rack.multiprocess' => false,
        'rack.run_once' => false
      )

      rack_env
    end
  end
end
