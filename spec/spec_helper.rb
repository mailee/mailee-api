$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec'
require 'active_record'
require 'mailee'

RSpec.configure do |config|
  Mailee::Config.site = "https://api.869a72b17b05a.mailee-api.mailee.me"
end
