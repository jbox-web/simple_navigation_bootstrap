# frozen_string_literal: true

require 'spec_helper'

# Characterization specs for the Bootstrap 5 renderer.
#
# Bootstrap 5 emits native markup that differs from BS2/3/4: 'nav-item'/'nav-link'
# on the anchor, 'data-bs-toggle' (bs- namespace) on toggles, '<hr class="dropdown-divider">'
# and '<h6 class="dropdown-header">' inside the '<li>', a CSS-driven caret (no '<b class="caret">'),
# 'aria-current="page"' on the selected link, and the native split via 'dropdown-toggle-split'.
# Bootstrap 5 has NO native nested dropdown, so deep submenus reuse the 'dropdown-submenu'
# pattern (requires the small CSS documented in the README).
RSpec.describe SimpleNavigationBootstrap::Bootstrap5 do

  let(:bootstrap_menu) { build_menu(version: 5) }

  describe '#render' do
    it "wraps main menu in ul-tag with 'nav navbar-nav' classes" do
      check_selector bootstrap_menu, 'ul.nav.navbar-nav > li#news'
    end

    it "sets up 'nav-item' on first level li-tags" do
      check_selector bootstrap_menu, 'ul.nav.navbar-nav > li.nav-item > a.nav-link[href="videos_path"]'
    end

    it "marks the selected link with 'active' and 'aria-current'" do
      check_selector bootstrap_menu, 'ul.nav.navbar-nav > li > a.nav-link.active[aria-current="page"][href="news_index_path"]'
    end

    it "wraps submenu in ul-tag 'dropdown-menu' class" do
      check_selector bootstrap_menu, 'ul.navbar-nav > li > ul.dropdown-menu > li > ul.dropdown-menu'
    end

    it "renders dropdown children as 'dropdown-item' links" do
      check_selector bootstrap_menu, 'ul.dropdown-menu > li > a.dropdown-item[href="main_info_page"]'
    end

    context 'for the first level dropdown (the second level menu)' do
      it "sets up 'nav-item dropdown' on the li-tag which contains that submenu" do
        check_selector bootstrap_menu, 'ul.navbar-nav > li.nav-item.dropdown > ul.dropdown-menu'
      end

      it "sets up 'nav-link dropdown-toggle' on the toggle link" do
        check_selector bootstrap_menu, 'ul.navbar-nav > li.dropdown > a.nav-link.dropdown-toggle'
      end

      it "sets up 'data-bs-toggle', 'role' and 'aria-expanded' on the toggle link" do
        check_selector bootstrap_menu, 'ul.navbar-nav > li.dropdown > a[data-bs-toggle="dropdown"][role="button"][aria-expanded="false"]'
      end

      it 'does not emit a caret element (BS5 draws it in CSS)' do
        check_selector bootstrap_menu, 'ul.navbar-nav > li.dropdown > a b.caret', 0
      end
    end

    context 'for nested submenu (the third level menu and deeper)' do
      it "reuses the 'dropdown-submenu' pattern on the li-tag which contains that submenu" do
        check_selector bootstrap_menu, 'ul.dropdown-menu > li.dropdown-submenu > a.dropdown-item.dropdown-toggle'
        check_selector bootstrap_menu, 'ul.dropdown-menu > li.dropdown-submenu > ul.dropdown-menu'
      end
    end

    context "when ':split' option provided" do
      it 'renders a single nav-item with an action link and a split toggle' do
        check_selector bootstrap_menu, 'ul.navbar-nav > li.nav-item.dropdown > a.nav-link[href="info_index_path"]'
        check_selector bootstrap_menu, 'li.dropdown > a.nav-link.dropdown-toggle.dropdown-toggle-split[data-bs-toggle="dropdown"]'
      end

      it 'does not split second level items (only first level splits)' do
        check_selector bootstrap_menu, 'ul.dropdown-menu > li.dropdown-toggle-split', 0
        check_selector bootstrap_menu, 'ul.dropdown-menu > li.dropdown-submenu > ul.dropdown-menu'
      end
    end

    context "when ':navbar_text' option provided" do
      it "creates a span-tag with class 'navbar-text' instead of a link" do
        check_selector bootstrap_menu, 'li.to_check_navbar_text > a', 0
        check_title    bootstrap_menu, 'li.to_check_navbar_text > span.navbar-text', 'Signed in as Pavel Shpak'
      end
    end

    context "when ':divider' option provided" do
      it "renders an '<hr class=\"dropdown-divider\">' inside the li-tag" do
        check_selector bootstrap_menu, 'ul.dropdown-menu > li > hr.dropdown-divider', 2
      end
    end

    context "when ':header' option provided" do
      context 'for the first level item' do
        it 'does not set up a header and renders a standard link' do
          check_selector bootstrap_menu, 'li.to_check_header > h6.dropdown-header', 0
          check_selector bootstrap_menu, 'li.to_check_header > a.nav-link'
        end
      end

      context 'for the second level item and deeper' do
        it "renders an '<h6 class=\"dropdown-header\">' without a link" do
          check_selector bootstrap_menu, 'li.to_check_header2 > a', 0
          check_title    bootstrap_menu, 'li.to_check_header2 > h6.dropdown-header', 'Misc. Pages'
        end
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
            build_menu(version: 5, stub_name: true)
          }.to raise_error(SimpleNavigationBootstrap::Error::InvalidHash)
        end
      end
    end

    describe 'name escaping' do
      it 'escapes a plain-string first level dropdown label' do
        menu = build_menu(version: 5, menu_name: :xss_menu)
        expect(menu.to_s).not_to include('<script>alert(1)</script>')
      end
    end

    describe "':skip_caret' option" do
      let(:menu) { build_menu(version: 5, menu_name: :skip_caret_menu) }

      it "keeps the 'dropdown-toggle' class by default and drops it when skip_caret is set" do
        check_selector menu, 'li.to_check_caret > a.dropdown-toggle'
        check_selector menu, 'li.to_check_no_caret > a.dropdown-toggle', 0
        check_selector menu, 'li.to_check_no_caret > a[data-bs-toggle="dropdown"]'
      end
    end

    it 'does not leak bootstrap-only option keys as HTML attributes' do
      %w[divider header navbar_text split skip_caret].each do |leaked|
        expect(bootstrap_menu.css("[#{leaked}]").size).to eq(0), "leaked '#{leaked}' attribute"
      end
    end

    context 'when container is empty' do
      let(:bootstrap_menu) { build_menu(version: 5, menu_name: :empty_menu, menu_opts: { skip_if_empty: true }) }

      it 'returns empty list' do
        check_selector bootstrap_menu, 'ul > li', 0
      end
    end
  end

end
