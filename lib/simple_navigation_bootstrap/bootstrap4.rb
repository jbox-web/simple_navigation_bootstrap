# frozen_string_literal: true

module SimpleNavigationBootstrap
  class Bootstrap4 < SimpleNavigation::Renderer::Base

    include BootstrapBase


    private


      def bootstrap_version
        4
      end


      def navigation_class
        'navbar-nav'
      end


      def container_class(_level)
        remove_navigation_class = options.fetch(:remove_navigation_class) { false }
        remove_navigation_class ? '' : ['nav', navigation_class].compact
      end

  end
end
