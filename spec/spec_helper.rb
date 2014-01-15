require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'rspec'
require 'signals'

RSpec.configure do |config|
  config.mock_with :rspec
end
