require 'simplecov'

# Start SimpleCov
SimpleCov.start do
  add_filter 'spec/'
end

# SimpleNavigation currently only works for Rails, Sinatra and Padrino apps
# This is a workaround to be able to test the lib
## START ##
ENV['RAILS_ENV'] = 'test'

require 'action_controller'
require 'action_view'

module Rails
  module VERSION
    MAJOR = 2
  end
end unless defined? Rails

RAILS_ROOT = './' unless defined?(RAILS_ROOT)
RAILS_ENV = 'test' unless defined?(RAILS_ENV)
## END ##

current_dir = File.expand_path(File.dirname(File.dirname(__FILE__)))

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories.
Dir[File.join(current_dir, 'spec/support/**/*.rb')].each { |f| require f }

# Configure RSpec
RSpec.configure do |config|
  # Include standard helpers
  config.include TestHelper
end

# Require the lib to test
require 'simple_navigation_bootstrap'
