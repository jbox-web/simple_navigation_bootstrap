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


      def render_item(*)
        SimpleNavigationBootstrap::RenderedItem5.new(*).to_s
      end

  end
end
