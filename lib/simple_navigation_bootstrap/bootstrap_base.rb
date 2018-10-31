# frozen_string_literal: true

module SimpleNavigationBootstrap
  module BootstrapBase

    def render(item_container)
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


      def render_item(*args)
        SimpleNavigationBootstrap::RenderedItem.new(*args).to_s
      end


      def container_class(level)
        remove_navigation_class = options.fetch(:remove_navigation_class) { false }
        if level == 1
          remove_navigation_class ? '' : ['nav', navigation_class].compact
        else
          'dropdown-menu'
        end
      end


      def with_bootstrap_configs
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
        result = yield

        # Restore config
        sn_config.name_generator = config_name_generator
        sn_config.selected_class = config_selected_class

        result
      end


      def prepare_name(name)
        return name unless name.is_a?(Hash)

        if name[:icon]
          icon_options = { class: name[:icon], title: name[:title] }.reject { |_, v| v.nil? }
          content_tag(:i, '', icon_options) + ' ' + (name[:text] || '')
        else
          name[:text] || (raise SimpleNavigationBootstrap::InvalidHash)
        end
      end

  end
end
