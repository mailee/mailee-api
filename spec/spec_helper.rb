$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec'
require 'active_record'
require 'mailee'
require "faraday_middleware"
require "her"
require 'json'

# this method removes the attributes used in the request
# to make it look like Object.attributes
def clear fixture
  fixture.delete("errors")
  fixture
end


RSpec.configure do |config|
  config.include(Module.new do
    def stub_api_for(klass)
      klass.use_api (api = Her::API.new)
      credentials = {api_key: "869a72b17b05a", subdomain: "mailee-api"}
      api.setup url: "https://api.mailee.me/v2/", params: credentials do |c|
        c.use Faraday::Request::UrlEncoded
        c.use Her::Middleware::DefaultParseJSON
        c.use Faraday::Adapter::NetHttp
        c.adapter(:test) { |s| yield(s) }
      end
    end
  end)

end
