# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SimpleNavigationBootstrap::BootstrapBase do

  describe 'global config restoration' do
    # An exception raised during rendering (e.g. InvalidHash) must not leave the
    # global SimpleNavigation.config singleton corrupted for subsequent renders.

    let(:sentinel) { proc { |name, _item| name } }

    around do |example|
      saved_selected  = SimpleNavigation.config.selected_class
      saved_generator = SimpleNavigation.config.name_generator
      example.run
    ensure
      SimpleNavigation.config.selected_class = saved_selected
      SimpleNavigation.config.name_generator = saved_generator
    end

    it "restores 'selected_class' after an exception during rendering" do
      SimpleNavigation.config.selected_class = 'my-sentinel'
      aggregate_failures do
        expect { build_menu(version: 3, stub_name: true) }.to raise_error(SimpleNavigationBootstrap::Error::InvalidHash)
        expect(SimpleNavigation.config.selected_class).to eq 'my-sentinel'
      end
    end

    it "restores 'name_generator' after an exception during rendering" do
      SimpleNavigation.config.name_generator = sentinel
      aggregate_failures do
        expect { build_menu(version: 3, stub_name: true) }.to raise_error(SimpleNavigationBootstrap::Error::InvalidHash)
        expect(SimpleNavigation.config.name_generator).to equal sentinel
      end
    end
  end


  describe 'HTML attribute hygiene' do
    let(:bootstrap_menu) { build_menu(version: 3) }

    it 'does not leak bootstrap-only option keys as HTML attributes' do
      %w[divider header navbar_text split skip_caret remove_navigation_class].each do |leaked|
        expect(bootstrap_menu.css("[#{leaked}]").size).to eq(0), "leaked '#{leaked}' attribute"
      end
    end
  end


  describe 'name escaping' do
    it 'escapes a plain-string first level dropdown label' do
      menu = build_menu(version: 3, menu_name: :xss_menu)
      expect(menu.to_s).not_to include('<script>alert(1)</script>')
    end

    it 'still renders the icon markup from a name Hash unescaped' do
      menu = build_menu(version: 3)
      check_selector menu, 'ul > li > a > i.fa.fa-fw.fa-bullhorn'
    end
  end


  describe "':skip_caret' option" do
    let(:menu) { build_menu(version: 3, menu_name: :skip_caret_menu) }

    it 'renders the caret by default and omits it when skip_caret is set' do
      check_selector menu, 'li.to_check_caret > a > b.caret'
      check_selector menu, 'li.to_check_no_caret > a > b.caret', 0
    end
  end


  describe "':remove_navigation_class' render option" do
    it "omits the 'nav' class on the root ul" do
      menu = build_menu(version: 3, menu_opts: { remove_navigation_class: true })
      check_selector menu, 'ul.nav', 0
    end
  end


  # Regression specs for https://github.com/jbox-web/simple_navigation_bootstrap/issues/5
  # Rendering a single level in isolation ('render_navigation(level: 2)') must
  # treat that level as the top-level navbar, not as a hidden 'dropdown-menu'.
  describe '#render with a single ":level" option' do

    context 'with the Bootstrap 3 renderer' do
      let(:menu) { build_menu_level(version: 3, level: 2) }

      it "wraps the isolated level in a top-level 'nav navbar-nav' ul, not 'dropdown-menu'" do
        check_selector menu, 'ul.nav.navbar-nav'
        check_selector menu, 'ul.dropdown-menu', 0
      end
    end

    context 'with the Bootstrap 4 renderer' do
      let(:menu) { build_menu_level(version: 4, level: 2) }

      it "wraps the isolated level in a top-level 'nav navbar-nav' ul" do
        check_selector menu, 'ul.nav.navbar-nav'
      end

      it 'renders its direct items as top-level list entries, not nested submenus' do
        check_selector menu, 'ul.nav.navbar-nav > li > a[href="/main_info_page"]'
        check_selector menu, 'li.dropdown-submenu', 0
      end
    end

    context 'with the Bootstrap 5 renderer' do
      let(:menu) { build_menu_level(version: 5, level: 2) }

      it "wraps the isolated level in a top-level 'nav navbar-nav' ul, not 'dropdown-menu'" do
        check_selector menu, 'ul.nav.navbar-nav'
        check_selector menu, 'ul.dropdown-menu', 0
      end

      it 'renders its direct items as top-level nav-link anchors' do
        check_selector menu, 'ul.nav.navbar-nav > li.nav-item > a.nav-link[href="/main_info_page"]'
      end
    end

  end

end
