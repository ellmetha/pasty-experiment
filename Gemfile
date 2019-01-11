source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'activerecord-session_store'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'gettext_i18n_rails'
gem 'jbuilder', '~> 2.5'
gem "pg", ">= 0.18"
gem "pgcli-rails"
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'
gem 'rails-i18n', '~> 5.1'
gem 'webpacker', '>= 4.0.x'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rails-controller-testing'
end

group :development do
  gem 'annotate'
  gem 'gettext', '>=3.0.2', :require => false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem "rubocop", require: false
  gem "simplecov", require: false
  gem "simplecov-console", require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end
