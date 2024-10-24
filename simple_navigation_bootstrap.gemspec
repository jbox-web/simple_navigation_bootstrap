# frozen_string_literal: true

require_relative 'lib/simple_navigation_bootstrap/version'

Gem::Specification.new do |s|
  s.name        = 'simple_navigation_bootstrap'
  s.version     = SimpleNavigationBootstrap::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Pavel Shpak', 'Nicolas Rodriguez']
  s.email       = ['shpakvel@gmail.com', 'nico@nicoladmin.fr']
  s.homepage    = 'https://github.com/jbox-web/simple_navigation_bootstrap'
  s.summary     = 'A Ruby gem that adds Bootstrap renderers for SimpleNavigation'
  s.description = 'This gem adds Bootstrap2 and Bootstrap3 renderers for SimpleNavigation'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 3.1.0'

  s.files = Dir['README.md', 'CHANGELOG.md', 'LICENSE', 'lib/**/*.rb', 'vendor/**/*.scss']

  s.add_dependency 'simple-navigation', '~> 4.0'
  s.add_dependency 'zeitwerk', '~> 2.6.0'
end
