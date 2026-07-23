# frozen_string_literal: true

require 'spec_helper'

# Characterization specs for the Bootstrap 4 renderer.
#
# NOTE: unlike Bootstrap 2/3, this renderer overrides #container_class to emit
# 'nav navbar-nav' at EVERY level, so submenus are NOT given the 'dropdown-menu'
# class that Bootstrap 4 expects for styled dropdowns. These specs lock in the
# current behaviour; whether the submenu markup should instead use
# 'dropdown-menu' is an open design question (see AUDIT COR-bootstrap4).
RSpec.describe SimpleNavigationBootstrap::Bootstrap4 do

  let(:bootstrap_menu) { build_menu(version: 4) }

  describe '#render' do
    it "wraps main menu in ul-tag with 'nav navbar-nav' classes" do
      check_selector bootstrap_menu, 'ul.nav.navbar-nav > li#news'
    end

    it "sets up 'active' class on selected items" do
      check_selector bootstrap_menu, 'ul.nav.navbar-nav > li.active > a[href="news_index_path"]'
    end

    it "renders submenus with 'nav navbar-nav' and not 'dropdown-menu' (BS4 override)" do
      check_selector bootstrap_menu, 'ul.dropdown-menu', 0
      # root + the two nested submenus all carry 'nav navbar-nav'
      check_selector bootstrap_menu, 'ul.nav.navbar-nav', 3
      check_selector bootstrap_menu, 'ul.nav.navbar-nav ul.nav.navbar-nav', 2
    end

    context "when ':header' option provided" do
      context 'for the first level item' do
        it 'does not set up header class and renders a standard link' do
          check_selector bootstrap_menu, 'li.to_check_header.nav-header', 0
          check_selector bootstrap_menu, 'li.to_check_header > a'
        end
      end

      context 'for the second level item and deeper' do
        it "sets up 'nav-header' class on li-tag without a link" do
          check_selector bootstrap_menu, 'li.to_check_header2.nav-header'
          check_selector bootstrap_menu, 'li.to_check_header2.nav-header > a', 0
          check_title    bootstrap_menu, 'li.to_check_header2.nav-header', 'Misc. Pages'
        end
      end
    end

    context "when ':divider' option provided" do
      it "adds 'divider-vertical' at first level and 'divider' deeper" do
        check_selector bootstrap_menu, 'ul.nav.navbar-nav > li.divider-vertical'
        check_selector bootstrap_menu, 'ul ul li.divider', 2
      end
    end

    context "when ':navbar_text' option provided" do
      it "creates p-tag with class 'navbar-text' instead of a link" do
        check_selector bootstrap_menu, 'li.to_check_navbar_text > a', 0
        check_title    bootstrap_menu, 'li.to_check_navbar_text > p.navbar-text', 'Signed in as Pavel Shpak'
      end
    end

    context "when 'hash' provided in place of 'name'" do
      it 'renders the icon i-tag with its classes and title' do
        check_selector bootstrap_menu, 'ul > li > a > i.fa.fa-fw.fa-bullhorn'
        check_selector bootstrap_menu, 'ul > li > a > i.fa.fa-fw.fa-book[title="Info"]'
      end

      context "without ':text' and ':icon' parameters" do
        it "raises 'InvalidHash' error" do
          expect {
            build_menu(version: 4, stub_name: true)
          }.to raise_error(SimpleNavigationBootstrap::Error::InvalidHash)
        end
      end
    end

    it 'does not leak bootstrap-only option keys as HTML attributes' do
      %w[divider header navbar_text split skip_caret].each do |leaked|
        expect(bootstrap_menu.css("[#{leaked}]").size).to eq(0), "leaked '#{leaked}' attribute"
      end
    end

    context 'when container is empty' do
      let(:bootstrap_menu) { build_menu(version: 4, menu_name: :empty_menu, menu_opts: { skip_if_empty: true }) }

      it 'returns empty list' do
        check_selector bootstrap_menu, 'ul > li', 0
      end
    end
  end

end
