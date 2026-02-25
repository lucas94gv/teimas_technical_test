source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.2"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors", "~> 3.0"

gem "jwt", "~> 3.1", ">= 3.1.2"

group :development do
  # Code formatter for Ruby. It enforces the Ruby style guide, detects potential code issues.
  # Useful for maintaining consistent code quality and style across the project.
  gem "rubocop", require: false
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Dotenv-Rails is a gem that loads environment variables from a `.env` file into the Rails application.
  # This is useful for managing configuration settings, API keys, and secrets in development and
  # test environments, keeping them out of version control and facilitating easier configuration management.
  gem "dotenv-rails", "~> 3.2"

  # RSpec-Rails integrates RSpec, a popular testing framework, with Rails applications.
  # It provides a suite of tools and helpers for writing and running unit, integration, and
  # system tests, allowing for a behavior-driven development (BDD) approach to testing and ensuring robust and
  # maintainable code.
  gem "rspec-rails", "~> 8.0", ">= 8.0.3"

  # FactoryBot is a fixtures replacement tool that allows you to create test data more easily and flexibly.
  # The 'factory_bot_rails' gem integrates FactoryBot with Rails, enabling you to define and
  # use factories in your tests to generate objects with default or custom attributes.
  gem "factory_bot_rails", "~> 6.5", ">= 6.5.1"

  # Faker is a library for generating fake data, useful for populating test databases or creating realistic sample data.
  # It provides a wide range of methods to generate random names, addresses, phone numbers, and
  # other types of data, which helps in creating more comprehensive and diverse test cases.
  gem "faker", "~> 3.6"
end
