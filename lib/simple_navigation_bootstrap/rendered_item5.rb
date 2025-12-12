# frozen_string_literal: true

module SimpleNavigationBootstrap
  class RenderedItem5 < RenderedItem
    private

    def li_link # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      if include_sub_navigation?(item)
        if level == 1
          if split
            splitted_simple_part + splitted_dropdown_part
          else
            content = [item.name]
            content << caret unless skip_caret
            content = content.join(" ").html_safe
            dropdown_part(content)
          end
        else
          content_tag(:li, dropdown_submenu_link, options)
        end
      else
        options[:class] = [options[:class], "nav-item"].flatten.compact.join(
          " "
        ) if level == 1
        content_tag(:li, simple_link, options)
      end
    end

    def dropdown_part(name) # rubocop:disable Metrics/AbcSize
      options[:class] = [options[:class], "nav-item", "dropdown"].flatten
        .compact
        .join(" ")
      link_options[:class] = [
        link_options[:class],
        "nav-link",
        "dropdown-toggle"
      ].flatten.compact.join(" ")
      link_options[:"role"] = "button"
      link_options[:"data-bs-toggle"] = "dropdown"
      link_options[:"aria-expanded"] = "false"

      content =
        link_to(name, "#", link_options) + render_sub_navigation_for(item)
      content_tag(:li, content, options)
    end

    def simple_link
      link_class = level == 1 ? "nav-link" : "dropdown-item"
      link_options[:class] = [options[:class], link_class].flatten.compact.join(" ")
      link_options[:method] ||= item.method
      url = item.url || "#"
      link_to(item.name, url, link_options)
    end
  end
end
