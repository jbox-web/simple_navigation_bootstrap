# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# Dev libs
gem 'actionpack'
gem 'actionview'
gem 'rake'
gem 'rspec'
gem 'simplecov'

# Dev tools / linter
gem 'guard-rspec',         require: false
gem 'rubocop',             require: false
gem 'rubocop-performance', require: false
gem 'rubocop-rake',        require: false
gem 'rubocop-rspec',       require: false

# Fix:
# warning: ostruct was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.5.0
# Add ostruct to your Gemfile or gemspec.
#
# warning: logger was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.5.0
# Add logger to your Gemfile or gemspec.
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.4.0')
  gem 'logger'
  gem 'ostruct'
end
