# frozen_string_literal: true

require_relative 'lib/simple_navigation_bootstrap/version'

Gem::Specification.new do |s|
  s.name        = 'simple_navigation_bootstrap'
  s.version     = SimpleNavigationBootstrap::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Pavel Shpak', 'Nicolas Rodriguez']
  s.email       = ['shpakvel@gmail.com', 'nrodriguez@jbox-web.com']
  s.homepage    = 'https://github.com/jbox-web/simple_navigation_bootstrap'
  s.summary     = 'A Ruby gem that adds Bootstrap renderers for SimpleNavigation'
  s.description = 'This gem adds Bootstrap2 and Bootstrap3 renderers for SimpleNavigation'
  s.license     = 'MIT'

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency 'simple-navigation', '~> 4.0'

  s.add_development_dependency 'actionpack'
  s.add_development_dependency 'actionview'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
end
