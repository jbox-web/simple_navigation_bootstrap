# frozen_string_literal: true

require 'forwardable'
require 'simple-navigation'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

module SimpleNavigationBootstrap
end

SimpleNavigation.register_renderer(bootstrap2: SimpleNavigationBootstrap::Bootstrap2)
SimpleNavigation.register_renderer(bootstrap3: SimpleNavigationBootstrap::Bootstrap3)
SimpleNavigation.register_renderer(bootstrap4: SimpleNavigationBootstrap::Bootstrap4)
