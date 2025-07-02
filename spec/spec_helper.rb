# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

# Start SimpleCov
SimpleCov.start do
  formatter SimpleCov::Formatter::JSONFormatter
  add_filter 'spec/'
end

# SimpleNavigation currently only works for Rails, Sinatra and Padrino apps
# This is a workaround to be able to test the lib
## START ##
ENV['RAILS_ENV'] = 'test'

require 'action_controller'
require 'action_view'

unless defined? Rails
  module Rails
    module VERSION
      MAJOR = 2
    end
  end
end

RAILS_ROOT = './' unless defined?(RAILS_ROOT)
RAILS_ENV = 'test' unless defined?(RAILS_ENV)
## END ##

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Configure RSpec
RSpec.configure do |config|
  config.color = true
  config.fail_fast = false

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable monkey patching
  # see: https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/zero-monkey-patching-mode
  config.disable_monkey_patching!

  config.raise_errors_for_deprecations!

  # Include standard helpers
  config.include TestHelper
end

# Require the lib to test
require 'simple_navigation_bootstrap'
