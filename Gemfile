# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Ruby version
ruby '3.1.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '7.0.8.6'

# Active Record is the M in MVC - the model
gem 'activerecord', '7.0.8.6'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# To login/logout users
gem 'sorcery', '0.16.3'

# To use amazon s3
gem 'aws-sdk-s3', require: false

# To use active storage
gem 'image_processing', '~> 1.2'

# To use active storage with vips
gem 'ruby-vips', '~> 2.2'

# Use dotenv to load environment variables from .env into ENV in development
gem 'dotenv-rails'

# Use RSpotify to use Spotify API
gem 'rspotify'

# Use scss for system
gem 'sassc-rails', '~> 2.1'

gem 'kaminari', '1.2.2'

gem 'bootstrap5-kaminari-views'

gem 'ransack'

gem 'rubocop', require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end

gem 'rails-html-sanitizer', '~> 1.6'

gem 'nokogiri', '~> 1.17'

gem 'erubi', '~> 1.13'

gem 'minitest', '~> 5.25'

gem 'rails-i18n'
