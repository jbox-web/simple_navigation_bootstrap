# frozen_string_literal: true

module SimpleNavigationBootstrap
  class RenderedItem
    extend Forwardable

    attr_reader :renderer
    def_delegators :renderer, :link_to, :content_tag, :include_sub_navigation?, :render_sub_navigation_for

    def initialize(renderer, item, level, bootstrap_version)
      @renderer = renderer
      @item     = item
      @level    = level
      @bootstrap_version = bootstrap_version

      @options      = item.html_options
      @navbar_text  = options.fetch(:navbar_text) { nil }
      @divider      = options.fetch(:divider) { false }
      @header       = options.fetch(:header) { false }
      @split        = options.fetch(:split) { false }
      @skip_caret   = options.fetch(:skip_caret) { false }
      @link_options = @item.link_html_options || {}
    end


    def to_s
      if navbar_text
        li_text
      elsif divider
        li_divider
      elsif header && (level != 1)
        li_header
      else
        li_link
      end
    end


    private


      attr_reader :item, :level, :bootstrap_version, :options, :navbar_text, :divider, :header, :split, :skip_caret, :link_options

      def li_text
        content_tag(:li, content_tag(:p, item.name, class: 'navbar-text'), options)
      end


      def li_divider
        css_class = level == 1 ? 'divider-vertical' : 'divider'
        options[:class] = [options[:class], css_class].flatten.compact.join(' ')
        content_tag(:li, '', options)
      end


      def li_header
        css_class = bootstrap_version == 3 ? 'dropdown-header' : 'nav-header'
        options[:class] = [options[:class], css_class].flatten.compact.join(' ')
        content_tag(:li, item.name, options)
      end


      def li_link
        if include_sub_navigation?(item)
          if level == 1
            if split
              splitted_simple_part + splitted_dropdown_part
            else
              content = [item.name]
              content << caret unless skip_caret
              content = content.join(' ').html_safe
              dropdown_part(content)
            end
          else
            content_tag(:li, dropdown_submenu_link, options)
          end
        else
          content_tag(:li, simple_link, options)
        end
      end


      def splitted_simple_part
        main_li_options = options.dup
        main_li_options[:class] = [main_li_options[:class], 'dropdown-split-left'].flatten.compact.join(' ')
        content_tag(:li, simple_link, main_li_options)
      end


      def splitted_dropdown_part
        item.sub_navigation.dom_class = [item.sub_navigation.dom_class, 'pull-right'].flatten.compact.join(' ')
        link_options = {}
        options[:id] = nil
        options[:class] = [options[:class], 'dropdown-split-right'].flatten.compact.join(' ')
        dropdown_part(caret)
      end


      def dropdown_part(name)
        options[:class] = [options[:class], 'dropdown'].flatten.compact.join(' ')
        link_options[:class] = [link_options[:class], 'dropdown-toggle'].flatten.compact.join(' ')
        link_options[:"data-toggle"] = 'dropdown'
        link_options[:"data-target"] = '#'

        content = link_to(name, '#', link_options) + render_sub_navigation_for(item)
        content_tag(:li, content, options)
      end


      def caret
        content_tag(:b, '', class: 'caret')
      end


      def dropdown_submenu_link
        options[:class] = [options[:class], 'dropdown-submenu'].flatten.compact.join(' ')
        simple_link + render_sub_navigation_for(item)
      end


      def simple_link
        link_options[:method] ||= item.method
        link_to(item.name, (item.url || '#'), link_options)
      end

  end
end
