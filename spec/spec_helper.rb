require 'simplecov'

SimpleCov.start do
  add_group "Signals", "/lib"
end

require 'rspec'
require 'signals'

RSpec.configure do |config|
  config.mock_with :rspec
end
