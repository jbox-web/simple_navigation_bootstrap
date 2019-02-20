# frozen_string_literal: true

require 'forwardable'
require 'simple-navigation'

module SimpleNavigationBootstrap
  require 'simple_navigation_bootstrap/error'
  require 'simple_navigation_bootstrap/rendered_item'
  require 'simple_navigation_bootstrap/bootstrap_base'
  require 'simple_navigation_bootstrap/bootstrap2'
  require 'simple_navigation_bootstrap/bootstrap3'
  require 'simple_navigation_bootstrap/bootstrap4'
  require 'simple_navigation_bootstrap/engine' if defined? Rails::Engine
end

SimpleNavigation.register_renderer(bootstrap2: SimpleNavigationBootstrap::Bootstrap2)
SimpleNavigation.register_renderer(bootstrap3: SimpleNavigationBootstrap::Bootstrap3)
SimpleNavigation.register_renderer(bootstrap4: SimpleNavigationBootstrap::Bootstrap4)
