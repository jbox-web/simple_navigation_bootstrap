# frozen_string_literal: true

require 'spec_helper'

describe SimpleNavigationBootstrap::Bootstrap3 do

  let(:bootstrap_menu) { build_menu(version: 3) }

  describe '#render' do
    it "wraps main menu in ul-tag with 'nav navbar-nav' classes" do
      check_selector bootstrap_menu, 'ul.nav.navbar-nav'
    end

    it "sets up 'active' class on selected items (on li-tags)" do
      check_selector bootstrap_menu, 'ul.nav.navbar-nav > li.active > a[href="news_index_path"]'
    end

    it "wraps submenu in ul-tag 'dropdown-menu' class" do
      check_selector bootstrap_menu, 'ul > li > ul.dropdown-menu > li > ul.dropdown-menu'
    end

    context 'for the first level submenu (the second level menu)' do
      it "sets up 'dropdown' class on li-tag which contains that submenu" do
        check_selector bootstrap_menu, 'ul > li.dropdown'
      end

      it "sets up 'dropdown-toggle' class on link-tag which is used for toggle that submenu" do
        check_selector bootstrap_menu, 'ul > li.dropdown > a.dropdown-toggle'
      end

      it "sets up 'data-toggle' attribute to 'dropdown' on link-tag which is used for toggle that submenu" do
        check_selector bootstrap_menu, 'ul > li.dropdown > a[data-toggle=dropdown]'
      end

      it "sets up 'data-target' attribute to '#' on link-tag which is used for toggle that submenu" do
        check_selector bootstrap_menu, 'ul > li.dropdown > a[data-target="#"]'
      end

      it "sets up 'href' attribute to '#' on link-tag which is used for toggle that submenu" do
        check_selector bootstrap_menu, 'ul > li.dropdown > a[href="#"]'
      end

      it "puts b-tag with 'caret' class in li-tag which contains that submenu" do
        check_selector bootstrap_menu, 'ul > li.dropdown > a[href="#"] > b.caret'
      end
    end

    context 'for nested submenu (the third level menu and deeper)' do
      it "sets up 'dropdown-submenu' class on li-tag which contains that submenu" do
        check_selector bootstrap_menu, 'ul > li > ul.dropdown-menu > li.dropdown-submenu'
      end
    end

    context "when ':split' option provided" do
      context 'for the first level item which contains submenu' do
        it 'splits item on two li-tags (left and right) and right li-tag will contain the first level submenu (second level menu)' do
          check_selector bootstrap_menu, 'ul > li.dropdown-split-left + li.dropdown.dropdown-split-right > ul.dropdown-menu'
        end

        it "sets up 'pull-right' class on ul-tag which is the submenu" do
          check_selector bootstrap_menu, 'ul > li > ul.dropdown-menu.pull-right'
        end
      end

      context 'for the second level item and deeper which contains submenu' do
        it 'does not splits item on two li-tags' do
          check_selector bootstrap_menu, 'ul.dropdown-menu > li.dropdown-split-left + li.dropdown.dropdown-split-right > ul.dropdown-menu', 0
          check_selector bootstrap_menu, 'ul.dropdown-menu > li.dropdown-submenu > ul.dropdown-menu'
        end

        it "does not sets up 'pull-right' class on ul-tag which is the submenu" do
          check_selector bootstrap_menu, 'ul.dropdown-menu > li > ul.dropdown-menu.pull-right', 0
        end
      end

      context 'for item which does not contain submenu' do
        it 'does not splits item on two li-tags' do
          check_selector bootstrap_menu, 'ul > li.to_check_split.dropdown-split-left + li.dropdown.dropdown-split-right', 0
          check_selector bootstrap_menu, 'ul > li.to_check_split'
        end
      end
    end

    context "when ':split' option is not provided" do
      let(:bootstrap_menu) { build_menu(version: 3, menu_name: :unsplited_menu) }

      context 'for the first level item which contains submenu' do
        it 'does not splits item on two li-tags (left and right) and right li-tag will contain the first level submenu (second level menu)' do
          check_selector bootstrap_menu, 'ul > li.dropdown-split-left + li.dropdown.dropdown-split-right > ul.dropdown-menu', 0
        end

        it "does not sets up 'pull-right' class on ul-tag which is the submenu" do
          check_selector bootstrap_menu, 'ul > li > ul.dropdown-menu.pull-right', 0
        end
      end

      context 'for the second level item and deeper which contains submenu' do
        it 'does not splits item on two li-tags' do
          check_selector bootstrap_menu, 'ul.dropdown-menu > li.dropdown-split-left + li.dropdown.dropdown-split-right > ul.dropdown-menu', 0
          check_selector bootstrap_menu, 'ul.dropdown-menu > li.dropdown-submenu > ul.dropdown-menu'
        end

        it "does not sets up 'pull-right' class on ul-tag which is the submenu" do
          check_selector bootstrap_menu, 'ul.dropdown-menu > li > ul.dropdown-menu.pull-right', 0
        end
      end

      context 'for item which does not contain submenu' do
        it 'does not splits item on two li-tags' do
          check_selector bootstrap_menu, 'ul > li.to_check_split.dropdown-split-left + li.dropdown.dropdown-split-right', 0
          check_selector bootstrap_menu, 'ul > li.to_check_split'
        end
      end
    end

    context "when ':navbar_text' option provided" do
      it "creates p-tag with class 'navbar-text' and item 'name' as a content instead of link-tag for the item (standard item)" do
        check_selector bootstrap_menu, 'ul > li.to_check_navbar_text > a', 0
        check_title    bootstrap_menu, 'ul > li.to_check_navbar_text > p.navbar-text', 'Signed in as Pavel Shpak'
      end
    end

    context "when ':divider' option provided" do
      it 'does not create link-tag for the item (standard item)' do
        check_selector bootstrap_menu, 'ul > li.divider-vertical + li > a[href="divider_before_info_index_path"]', 0
        check_selector bootstrap_menu, 'ul.dropdown-menu > li.divider + li > a[href="divider_before_misc_info_pages"]', 0
        check_selector bootstrap_menu, 'ul.dropdown-menu > li.divider + li > a[href="divider_before_contact_info_page"]', 0
      end

      context 'for the first level item' do
        it "adds li-tag with class 'divider-vertical'" do
          check_selector bootstrap_menu, 'ul > li.divider-vertical + li > a[href="info_index_path"]'
        end
      end

      context 'for the second level item and deeper' do
        it "adds li-tag with class 'divider'" do
          check_selector bootstrap_menu, 'ul.dropdown-menu > li.divider + li > a[href="misc_info_pages"]'
          check_selector bootstrap_menu, 'ul.dropdown-menu > li.divider + li > a[href="contact_info_page"]'
        end
      end
    end

    context "when ':header' option provided" do
      context 'for the first level item' do
        it "does not set up 'dropdown-header' or 'nav-header' class on li-tag" do
          check_selector bootstrap_menu, 'ul.nav.navbar-nav > li.to_check_header.dropdown-header', 0
        end

        it 'creates link-tag for the item (standard item)' do
          check_selector bootstrap_menu, 'ul.nav.navbar-nav > li.to_check_header > a'
        end
      end

      context 'for the second level item and deeper' do
        it "sets up 'dropdown-header' class on li-tag" do
          check_selector bootstrap_menu, 'ul.dropdown-menu > li.to_check_header2.dropdown-header'
        end

        it "does not create link-tag for the item (standard item), but puts only item 'name'" do
          check_selector bootstrap_menu, 'ul.dropdown-menu > li.to_check_header2.dropdown-header > a', 0
          check_title    bootstrap_menu, 'ul.dropdown-menu > li.to_check_header2.dropdown-header', 'Misc. Pages'
        end
      end
    end

    context "when 'hash' provided in place of 'name'" do
      context "with ':icon' parameter" do
        it 'adds i-tag with classes from the parameter' do
          check_selector bootstrap_menu, 'ul > li > a > i.fa.fa-fw.fa-bullhorn'
        end
      end

      context "with ':title' parameter" do
        it "sets up 'title' attribute on icon's i-tag to the parameter value" do
          check_selector bootstrap_menu, 'ul > li > a > i.fa.fa-fw.fa-book[title="Info"]'
        end
      end

      context "with ':text' parameter" do
        it "uses the parameter value as 'name' of the item" do
          expect(build_menu(version: 3).css('ul > li > a > i.fa.fa-fw.fa-bullhorn')[0].parent.children[1].to_s).to eq ' News'
        end
      end

      context "without ':text' and ':icon' parameters" do
        it "raises 'InvalidHash' error" do
          expect {
            build_menu(version: 3, stub_name: true)
          }.to raise_error(SimpleNavigationBootstrap::Error::InvalidHash)
        end
      end
    end

    context 'when container is empty' do
      let(:bootstrap_menu) { build_menu(version: 3, menu_name: :empty_menu, menu_opts: { skip_if_empty: true }) }

      it 'return empty list' do
        check_selector bootstrap_menu, 'ul > li', 0
      end
    end
  end

end
