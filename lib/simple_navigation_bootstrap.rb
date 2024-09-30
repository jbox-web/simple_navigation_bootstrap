# frozen_string_literal: true

# require ruby dependencies
require 'forwardable'

# require external dependencies
require 'simple-navigation'
require 'zeitwerk'

# load zeitwerk
Zeitwerk::Loader.for_gem.tap do |loader| # rubocop:disable Style/SymbolProc
  loader.setup
end

module SimpleNavigationBootstrap
end

SimpleNavigation.register_renderer(bootstrap2: SimpleNavigationBootstrap::Bootstrap2)
SimpleNavigation.register_renderer(bootstrap3: SimpleNavigationBootstrap::Bootstrap3)
SimpleNavigation.register_renderer(bootstrap4: SimpleNavigationBootstrap::Bootstrap4)
