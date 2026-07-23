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


      # Bootstrap 4 uses 'nav navbar-nav' at every level (no 'dropdown-menu' for submenus)
      def container_class(_level)
        navigation_container_class
      end

  end
end
