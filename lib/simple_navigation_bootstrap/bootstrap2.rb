# frozen_string_literal: true

module SimpleNavigationBootstrap
  class Bootstrap2 < SimpleNavigation::Renderer::Base

    include BootstrapBase


    private


      def bootstrap_version
        2
      end


      def navigation_class
        nil
      end

  end
end
