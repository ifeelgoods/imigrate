ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment", __FILE__)

require 'rails/test_help'
require 'rspec/rails'
require 'imigrate'
require 'database_cleaner'

MIGRATOR_ROOT = File.expand_path('../..', __FILE__)

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|

  config.mock_with :rspec

end