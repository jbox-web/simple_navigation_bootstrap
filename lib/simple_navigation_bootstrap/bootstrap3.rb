module SimpleNavigationBootstrap
  class Bootstrap3 < SimpleNavigation::Renderer::Base

    include BootstrapBase


    private


      def bootstrap_version
        3
      end


      def navigation_class
        'navbar-nav'
      end

  end
end
