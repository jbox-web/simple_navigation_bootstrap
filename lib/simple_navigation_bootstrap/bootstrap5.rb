# frozen_string_literal: true

module SimpleNavigationBootstrap
  class Bootstrap5 < SimpleNavigation::Renderer::Base

    include BootstrapBase


    private


      def bootstrap_version
        5
      end


      def navigation_class
        'navbar-nav'
      end


      # Bootstrap 5 keeps 'dropdown-menu' for submenus (default container_class),
      # so, unlike Bootstrap 4, container_class is NOT overridden here.
      def render_item(*)
        SimpleNavigationBootstrap::RenderedItem5.new(*).to_s
      end

  end
end
