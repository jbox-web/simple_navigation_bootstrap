# frozen_string_literal: true

module TestHelper # rubocop:disable Metrics/ModuleLength

  def build_menu(version:, menu_name: :splited_menu, stub_name: false, menu_opts: {})
    case version
    when 2
      render_result(SimpleNavigationBootstrap::Bootstrap2, menu_name, stub_name, menu_opts)
    when 3
      render_result(SimpleNavigationBootstrap::Bootstrap3, menu_name, stub_name, menu_opts)
    when 4
      render_result(SimpleNavigationBootstrap::Bootstrap4, menu_name, stub_name, menu_opts)
    when 5
      render_result(SimpleNavigationBootstrap::Bootstrap5, menu_name, stub_name, menu_opts)
    end
  end


  def check_selector(nav_menu, selector, nb_entries = 1)
    expect(nav_menu.css(selector).size).to eq nb_entries
  end


  def check_title(menu, selector, title)
    expect(menu.css(selector)[0].children[0].to_s).to eq title
  end


  private


    # 'stub_name' neads to check raising error when invalid 'Item name hash' provided
    #
    def render_result(renderer, menu_name, stub_name, opts = {})
      menu_opts = opts.merge(expand_all: true)
      prepare_navigation_instance(renderer)
      main_menu = build_main_menu(menu_name, stub_name).render(menu_opts)
      html_document(main_menu)
    end


    def prepare_navigation_instance(renderer)
      SimpleNavigation::Configuration.instance.renderer = renderer
      allow(SimpleNavigation).to receive_messages(adapter: simple_navigation_adapter)
      allow_any_instance_of(SimpleNavigation::Item).to receive_messages(selected?: false, selected_by_condition?: false) # rubocop:disable RSpec/AnyInstance
    end


    def simple_navigation_adapter
      SimpleNavigation::Adapters::Rails.new(
        double(:context, view_context: ActionView::Base.new(ActionController::Base.view_paths, {}, ActionController::Base.new)) # rubocop:disable RSpec/VerifiedDoubles
      )
    end


    def build_main_menu(menu_name, stub_name)
      # Create a new container
      main_menu = SimpleNavigation::ItemContainer.new(1)
      # Fill it with menu
      send(menu_name, main_menu)
      # Mark one entry as selected
      selected = main_menu.items.find { |item| item.key == :news }
      allow(selected).to receive_messages(selected?: true, selected_by_condition?: true)
      # Stub if needed
      main_menu.items[0].instance_variable_set(:@name, {}) if stub_name
      # Return menu
      main_menu
    end


    def html_document(html)
      Loofah.fragment(html)
    end


    ### TESTED NAVIGATION CONTENT ###


    def splited_menu(primary) # rubocop:disable Metrics/MethodLength
      primary.item :news, { icon: 'fa fa-fw fa-bullhorn', text: 'News' }, 'news_index_path'
      primary.item :concerts, 'Concerts', 'concerts_path', html: { class: 'to_check_header', header: true }
      primary.item :video, 'Video', 'videos_path', html: { class: 'to_check_split', split: true }
      primary.item :divider_before_info_index_path, '', '#', html: { divider: true }
      primary.item :info, { icon: 'fa fa-fw fa-book', title: 'Info' }, 'info_index_path', html: { split: true } do |info_nav|
        info_nav.item :main_info_page, 'Main info page', 'main_info_page'
        info_nav.item :about_info_page, 'About', 'about_info_page'
        info_nav.item :divider_before_misc_info_pages, '', '#', html: { divider: true }
        info_nav.item :misc_info_pages, 'Misc.', 'misc_info_pages', html: { split: true } do |misc_nav|
          misc_nav.item :header_misc_pages, 'Misc. Pages', '#', html: { class: 'to_check_header2', header: true }
          misc_nav.item :page1, 'Page1', 'page1'
          misc_nav.item :page2, 'Page2', 'page2'
        end
        info_nav.item :divider_before_contact_info_page, '', '#', html: { divider: true }
        info_nav.item :contact_info_page, 'Contact', 'contact_info_page'
      end
      primary.item :signed_in, 'Signed in as Pavel Shpak', '#', html: { class: 'to_check_navbar_text', navbar_text: true }
    end


    def unsplited_menu(primary) # rubocop:disable Metrics/MethodLength
      primary.item :news, { icon: 'fa fa-fw fa-bullhorn', text: 'News' }, 'news_index_path'
      primary.item :concerts, 'Concerts', 'concerts_path', html: { class: 'to_check_header', header: true }
      primary.item :video, 'Video', 'videos_path', html: { class: 'to_check_split', split: true }
      primary.item :divider_before_info_index_path, '', '#', html: { divider: true }
      primary.item :info, { icon: 'fa fa-fw fa-book', title: 'Info' }, 'info_index_path', html: { split: false } do |info_nav|
        info_nav.item :main_info_page, 'Main info page', 'main_info_page'
        info_nav.item :about_info_page, 'About', 'about_info_page'
        info_nav.item :divider_before_misc_info_pages, '', '#', html: { divider: true }
        info_nav.item :misc_info_pages, 'Misc.', 'misc_info_pages', html: { split: true } do |misc_nav|
          misc_nav.item :header_misc_pages, 'Misc. Pages', '#', html: { class: 'to_check_header2', header: true }
          misc_nav.item :page1, 'Page1', 'page1'
          misc_nav.item :page2, 'Page2', 'page2'
        end
        info_nav.item :divider_before_contact_info_page, '', '#', html: { divider: true }
        info_nav.item :contact_info_page, 'Contact', 'contact_info_page'
      end
      primary.item :signed_in, 'Signed in as Pavel Shpak', '#', html: { class: 'to_check_navbar_text', navbar_text: true }
    end


    def demo_menu(primary) # rubocop:disable Metrics/MethodLength
      primary.item :news, { icon: 'fa fa-fw fa-bullhorn', text: 'News' }, '/news_index_path'
      primary.item :concerts, 'Concerts', '/concerts_path'
      primary.item :video, 'Video', '/videos_path'
      primary.item :divider_before_info, '', '#', html: { divider: true }
      primary.item :info, { icon: 'fa fa-fw fa-book', title: 'Info' }, '/info_index_path', html: { split: true } do |info_nav|
        info_nav.item :main_info_page, 'Main info page', '/main_info_page'
        info_nav.item :about_info_page, 'About', '/about_info_page'
        info_nav.item :misc_info_pages, 'Misc.', '#' do |misc_nav|
          misc_nav.item :header_misc_pages, 'Misc. Pages', '#', html: { header: true }
          misc_nav.item :page1, 'Page1', '/page1'
          misc_nav.item :page2, 'Page2', '/page2'
        end
        info_nav.item :divider_before_contact_info_page, '', '#', html: { divider: true }
        info_nav.item :contact_info_page, 'Contact', '/contact_info_page'
      end
      primary.item :signed_in, 'Signed in as Pavel Shpak', '#', html: { navbar_text: true }
    end


    def empty_menu(primary); end


    # First level dropdown item whose name is a plain string containing HTML,
    # used to check that plain-string labels are escaped (not marked html_safe blindly)
    def xss_menu(primary)
      primary.item :news, 'News', 'news_index_path'
      primary.item :danger, '<script>alert(1)</script>', '#' do |sub_nav|
        sub_nav.item :child, 'Child', 'child_path'
      end
    end


    # Two first level dropdown items, one with ':skip_caret' set, to check the caret is omitted
    def skip_caret_menu(primary)
      primary.item :news, 'News', 'news_index_path'
      primary.item :with_caret, 'WithCaret', '#', html: { class: 'to_check_caret' } do |sub_nav|
        sub_nav.item :child1, 'Child1', 'child1_path'
      end
      primary.item :no_caret, 'NoCaret', '#', html: { class: 'to_check_no_caret', skip_caret: true } do |sub_nav|
        sub_nav.item :child2, 'Child2', 'child2_path'
      end
    end

end
