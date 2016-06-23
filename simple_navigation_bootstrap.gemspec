# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'simple_navigation_bootstrap/version'

Gem::Specification.new do |s|
  s.name        = 'simple_navigation_bootstrap'
  s.version     = SimpleNavigationBootstrap::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Pavel Shpak', 'Nicolas Rodriguez']
  s.email       = ['shpakvel@gmail.com', 'nrodriguez@jbox-web.com']
  s.homepage    = 'https://github.com/jbox-web/simple_navigation_bootstrap'
  s.summary     = %q{A Ruby gem that adds Bootstrap renderers for SimpleNavigation}
  s.description = %q{This gem adds Bootstrap2 and Bootstrap3 renderers for SimpleNavigation}
  s.license     = 'MIT'

  s.add_runtime_dependency 'simple-navigation', '~> 4.0'

  s.add_development_dependency 'actionpack'
  s.add_development_dependency 'actionview'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
