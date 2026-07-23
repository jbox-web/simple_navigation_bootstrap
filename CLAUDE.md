# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Ruby gem that adds Bootstrap 2, 3 and 4 navbar renderers for the [simple-navigation](https://github.com/codeplant/simple-navigation) gem (`~> 4.0`). Fork of `ShPakvel/simple_navigation_renderers`. Consumers select a renderer via `render_navigation(renderer: :bootstrap3)` or by setting `navigation.renderer` in `config/navigation.rb`; the three renderers register themselves under `:bootstrap2/3/4` at load time.

## Commands

Always use the project binstubs (`bin/rspec`, `bin/rubocop`, `bin/rake`, `bin/bundle`) — never `bundle exec` or a globally installed gem.

- `bin/rake` — default task, runs the full RSpec suite
- `bin/rspec` — run all specs
- `bin/rspec spec/lib/simple_navigation_bootstrap/bootstrap3_spec.rb` — run one spec file
- `bin/rspec path/to/spec.rb:LINE` — run a single example by line
- `bin/rubocop` — lint (mirrors the CI `rubocop` job)
- `bin/guard` — watch files and re-run specs on change

## Architecture

The rendering logic lives in three pieces:

- `BootstrapBase` (`bootstrap_base.rb`) — the mixin holding all shared rendering. Its `render(item_container)` builds the `<ul>`, iterates items, and — via `with_bootstrap_configs` — temporarily overrides simple-navigation's global `SimpleNavigation.config` (forces `selected_class = 'active'`, wraps `name_generator` to run names through `prepare_name`) then restores it. `prepare_name` is what turns a `{ text:, icon:, title: }` name Hash into an `<i>` icon + text, raising `Error::InvalidHash` when neither `text` nor `icon` is present.
- `Bootstrap2/3/4` (`bootstrap2.rb`, etc.) — thin subclasses of `SimpleNavigation::Renderer::Base` that `include BootstrapBase` and only supply the per-version deltas: `bootstrap_version` (2/3/4), `navigation_class` (`nil` for BS2, `navbar-nav` for BS3/4), and — Bootstrap 4 only — an override of `container_class` (BS4 uses `nav navbar-nav` at every level instead of `dropdown-menu` for submenus).
- `RenderedItem` (`rendered_item.rb`) — renders one `<li>`. `to_s` dispatches on the item's html_options to one of: navbar-text, divider, header, or link. Link rendering handles submenus, the `split` option (splits a first-level link into a `dropdown-split-left` link + `dropdown-split-right` caret toggle), carets, and nested `dropdown-submenu` links. It delegates `link_to`/`content_tag`/`render_sub_navigation_for` back to the renderer via `Forwardable`.

Item behaviour is driven by html_options passed through simple-navigation: `:split`, `:navbar_text`, `:divider`, `:header`, `:skip_caret`, `:remove_navigation_class`, plus the name Hash. The README documents each from the consumer side.

Autoloading is Zeitwerk (`Zeitwerk::Loader.for_gem` in `lib/simple_navigation_bootstrap.rb`); new files under `lib/simple_navigation_bootstrap/` are picked up by convention — no manual `require`.

## Testing approach

simple-navigation only officially supports Rails/Sinatra/Padrino, so `spec/spec_helper.rb` stubs a minimal `Rails` constant and loads `action_controller`/`action_view` to get a working render context. `spec/support/test_helper.rb` is the heart of the suite: `build_menu(version:, menu_name:, ...)` wires up a real `SimpleNavigation::ItemContainer`, injects a stubbed Rails adapter/view context, marks the `:news` item selected, renders, and returns a `Loofah` fragment. Specs assert on the produced HTML with `check_selector`/`check_title` (CSS selector counts and node text). The predefined menus (`splited_menu`, `unsplited_menu`, `demo_menu`, `empty_menu`) are the fixtures exercised across Bootstrap versions.

## Version bumps

`lib/simple_navigation_bootstrap/version.rb` (`MAJOR/MINOR/TINY/PRE`) is the single source of truth, consumed by the gemspec. Update `CHANGELOG.md` alongside it.
