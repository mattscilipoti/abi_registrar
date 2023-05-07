source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.4"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.2", ">= 7.0.2.3"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# App Custom gems
gem 'active_record_doctor', group: :development
gem 'addressable'
gem 'address_composer', "~> 1.0", require: false
gem 'amazing_print', "~> 1.4" # Pretty print your Ruby objects with style -- in full color and with proper indentation
gem 'bullet', group: [:development] # help to kill N+1 queries and unused eager loading
gem 'database_cleaner-active_record', require: false# , group: [:development, :test]
gem 'draper' # Decorators/View-Models for Rails Applications
gem 'factory_bot_rails', require: false #, group: [:development, :test]
gem 'faker', require: false #, group: [:development, :test]
gem 'html2slim', require: false, group: :development
gem "nilify_blanks" # a framework for saving incoming blank values as nil
gem 'paper_trail'
gem 'pg_search'
gem 'railroady', group: :development # UML class diagram generator.
gem 'rails_semantic_logger' # feature rich logging framework
gem 'rodauth-rails', '~> 1.4' # Ruby's Most Advanced Authentication Framework
gem 'rspec-rails', group: [:development, :test]
# gem 'ruby_postal', require: false # Ruby bindings to libpostal for fast international address parsing/normalization
gem 'sassc-rails'
gem 'schema_plus_functions' # adding support for SQL functions
gem 'simple_form' # Forms made easy for Rails
gem 'slim-rails' # template language, reduces the syntax without becoming cryptic.
gem 'StreetAddress', require: false #
gem 'wannabe_bool', require: false # convert user input to boolean

