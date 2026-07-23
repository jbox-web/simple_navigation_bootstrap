## CHANGELOG

### Unreleased

* Fix: restore global SimpleNavigation config even when rendering raises (no more leaked `selected_class`/`name_generator`)
* Fix: escape plain-string dropdown labels instead of marking them html_safe blindly
* Fix: stop leaking bootstrap-only options (`divider`, `header`, `navbar_text`, `split`, `skip_caret`) as HTML attributes
* Add Bootstrap4 renderer specs
* Require Ruby >= 3.2, test against Ruby 3.3 / 3.4 / 4.0
* Switch code coverage from Code Climate to qlty
* Relax version constraint on zeitwerk

### 1.3.0 - 2020-04-05

* Add support of Ruby 2.7
* Switch to Zeitwerk to load gem files
* Add binstubs to ease development
* Drop support of Ruby 2.3

* This is the last version to support Ruby 2.4.x

### 1.2.0 - 2019-02-09

* Add Bootstrap4 renderer


### 1.1.1 - 2018-10-31

* Use Hash#fetch instead of #delete to not change menu options


### 1.1.0 - 2018-08-27

* Add magic comment # frozen_string_literal: true
* Coding style
* Fix deprecation warning: Extra .css in SCSS file is unnecessary (thanks gltarsa)


### 1.0.1 - 2016-06-24

* Use \<i\> tag for icons


### 1.0.0 - 2016-06-24

First release !
