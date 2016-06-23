require 'spec_helper'

describe SimpleNavigationBootstrap::Bootstrap2 do

  describe '#render' do

    it "wraps main menu in ul-tag with 'nav' class" do
      check_selector build_menu(version: 2), 'ul.nav.navbar-nav', 0
      check_selector build_menu(version: 2), 'ul.nav'
    end


    context "when ':header' option provided" do
      context "for the first level item" do
        it "does not set up 'dropdown-header' or 'nav-header' class on li-tag" do
          check_selector build_menu(version: 2), 'ul.nav > li.to_check_header.nav-header', 0
        end

        it "creates link-tag for the item (standard item)" do
          check_selector build_menu(version: 2), 'ul.nav > li.to_check_header > a'
        end
      end

      context "for the second level item and deeper" do
        it "sets up 'nav-header' class on li-tag" do
          check_selector build_menu(version: 2), 'ul.dropdown-menu > li.to_check_header2.nav-header'
        end

        it "does not create link-tag for the item (standard item), but puts only item 'name'" do
          check_selector build_menu(version: 2), 'ul.dropdown-menu > li.to_check_header2.nav-header > a', 0
          check_title build_menu(version: 2), 'ul.dropdown-menu > li.to_check_header2.nav-header', 'Misc. Pages'
        end
      end
    end


    context "when ':navbar_text' option provided" do
      it "creates p-tag with class 'navbar-text' and item 'name' as a content instead of link-tag for the item (standard item)" do
        check_selector build_menu(version: 2), 'ul > li.to_check_navbar_text > a', 0
        check_title build_menu(version: 2), 'ul > li.to_check_navbar_text > p.navbar-text', 'Signed in as Pavel Shpak'
      end
    end


    context "when container is empty" do
      it 'return empty list' do
        check_selector build_menu(version: 2, menu_name: :empty_menu, menu_opts: { skip_if_empty: true }), 'ul > li', 0
      end
    end

  end

end
