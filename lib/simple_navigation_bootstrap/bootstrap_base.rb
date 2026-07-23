# frozen_string_literal: true

module SimpleNavigationBootstrap
  module BootstrapBase

    def render(item_container) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      if skip_if_empty? && item_container.empty?
        ''
      else
        # Generate list of items
        list_content = with_bootstrap_configs do
          item_container.items.inject([]) do |list, item|
            list << render_item(self, item, item_container.level, bootstrap_version)
          end.join
        end

        # Set CSS class for container :
        #   class = 'nav' if level == 1
        #   class = 'dropdown-menu' if level > 1
        item_container.dom_class = [item_container.dom_class, container_class(item_container.level)].flatten.compact.join(' ')

        # Generate the final list
        content_tag(:ul, list_content, id: item_container.dom_id, class: item_container.dom_class)
      end
    end


    private


      def render_item(*)
        SimpleNavigationBootstrap::RenderedItem.new(*).to_s
      end


      def container_class(level)
        level == 1 ? navigation_container_class : 'dropdown-menu'
      end


      # The root container class, honouring the ':remove_navigation_class' render option
      def navigation_container_class
        options.fetch(:remove_navigation_class, false) ? '' : ['nav', navigation_class].compact
      end


      # NOTE: this mutates the process-global SimpleNavigation.config singleton
      # (selected_class, name_generator) for the duration of the render. It is
      # therefore not thread-safe: concurrent renders on a multi-threaded server
      # (e.g. Puma) may interleave. The 'ensure' below at least guarantees the
      # global state is restored even when the rendered block raises.
      def with_bootstrap_configs # rubocop:disable Metrics/MethodLength
        # Get current config
        sn_config = SimpleNavigation.config

        # Save current config
        config_selected_class    = sn_config.selected_class
        config_name_generator    = sn_config.name_generator
        sn_config.selected_class = 'active'

        # name_generator should be proc (not lambda or method) to be compatible with earlier versions of simple-navigation
        sn_config.name_generator = proc do |name, item|
          config_name_generator.call(prepare_name(name), item)
        end

        # Generate menu
        yield
      ensure
        # Restore config, even if the rendered block raised (e.g. InvalidHash),
        # otherwise the global singleton stays corrupted for later renders.
        sn_config.name_generator = config_name_generator
        sn_config.selected_class = config_selected_class
      end


      def prepare_name(name)
        return name unless name.is_a?(Hash)

        if name[:icon]
          icon_options = { class: name[:icon], title: name[:title] }.compact
          content_tag(:i, '', icon_options) + ' ' + (name[:text] || '') # rubocop:disable Style/StringConcatenation
        else
          name[:text] || (raise SimpleNavigationBootstrap::Error::InvalidHash)
        end
      end

  end
end
