# frozen_string_literal: true

module SimpleNavigationBootstrap
  # Renders one <li> using native Bootstrap 5 markup. Overrides only the pieces
  # that differ from the shared RenderedItem: 'nav-link'/'dropdown-item' link
  # classes, the 'bs-' toggle namespace, the CSS-driven caret, the '<hr>'/'<h6>'
  # based divider/header and the native split toggle. Icon name Hash handling,
  # selected handling and sub-navigation recursion are inherited unchanged.
  class RenderedItem5 < RenderedItem
    private

      # Bootstrap 5 uses a <span class="navbar-text"> wrapped in a nav-item <li>.
      def li_text
        options[:class] = [options[:class], 'nav-item'].flatten.compact.join(' ')
        content_tag(:li, content_tag(:span, item.name, class: 'navbar-text'), options)
      end


      # Bootstrap 5 divider is an <hr class="dropdown-divider"> inside the <li>.
      def li_divider
        content_tag(:li, content_tag(:hr, '', class: 'dropdown-divider'), options)
      end


      # Bootstrap 5 header is an <h6 class="dropdown-header"> inside the <li>.
      def li_header
        content_tag(:li, content_tag(:h6, item.name, class: 'dropdown-header'), options)
      end


      def li_link # rubocop:disable Metrics/AbcSize
        if include_sub_navigation?(item)
          if level == 1
            split ? split_dropdown : dropdown_part(item.name)
          else
            content_tag(:li, dropdown_submenu_link, options)
          end
        else
          options[:class] = [options[:class], 'nav-item'].flatten.compact.join(' ') if level == 1
          content_tag(:li, simple_link, options)
        end
      end


      # First level dropdown toggle. 'name' is passed as-is to link_to, which
      # escapes a plain-string label and preserves already-safe icon markup, so
      # a string name can never inject raw HTML.
      def dropdown_part(name) # rubocop:disable Metrics/AbcSize
        options[:class] = [options[:class], 'nav-item', 'dropdown'].flatten.compact.join(' ')
        toggle_classes = skip_caret ? ['nav-link'] : %w[nav-link dropdown-toggle]
        link_options[:class] = [link_options[:class], *toggle_classes].flatten.compact.join(' ')
        link_options[:role]             = 'button'
        link_options[:'data-bs-toggle'] = 'dropdown'
        link_options[:'aria-expanded']  = 'false'

        content = link_to(name, '#', link_options) + render_sub_navigation_for(item)
        content_tag(:li, content, options)
      end


      # Native Bootstrap 5 split: a single 'nav-item dropdown' <li> holding a plain
      # action link plus a separate 'dropdown-toggle-split' caret toggle.
      def split_dropdown
        options[:class] = [options[:class], 'nav-item', 'dropdown'].flatten.compact.join(' ')
        toggle_options = {
          class: 'nav-link dropdown-toggle dropdown-toggle-split',
          role: 'button',
          'data-bs-toggle': 'dropdown',
          'aria-expanded': 'false'
        }
        toggle = link_to(content_tag(:span, 'Toggle Dropdown', class: 'visually-hidden'), '#', toggle_options)
        content_tag(:li, simple_link + toggle + render_sub_navigation_for(item), options)
      end


      # Nested submenu (level > 1). Bootstrap 5 has no native nested dropdown; the
      # 'dropdown-submenu' pattern (styled by the small CSS documented in the
      # README) preserves the hierarchy.
      def dropdown_submenu_link # rubocop:disable Metrics/AbcSize
        options[:class] = [options[:class], 'dropdown-submenu'].flatten.compact.join(' ')
        link_options[:class] = [link_options[:class], 'dropdown-item', 'dropdown-toggle'].flatten.compact.join(' ')
        link_options[:method] ||= item.method
        link_to(item.name, item.url || '#', link_options) + render_sub_navigation_for(item)
      end


      def simple_link # rubocop:disable Metrics/AbcSize
        link_class = level == 1 ? 'nav-link' : 'dropdown-item'
        link_options[:class] = [link_options[:class], link_class, item.selected_class].flatten.compact.join(' ')
        link_options[:'aria-current'] = 'page' if item.selected?
        link_options[:method] ||= item.method
        link_to(item.name, item.url || '#', link_options)
      end

  end
end
