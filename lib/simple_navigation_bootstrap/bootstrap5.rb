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


      # def container_class(_level)
      #   remove_navigation_class = options.fetch(:remove_navigation_class, false)
      #   remove_navigation_class ? '' : ['nav', navigation_class].compact
      # end

  end
end
