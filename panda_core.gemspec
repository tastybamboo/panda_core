# frozen_string_literal: true

require_relative "lib/panda_core/version"

Gem::Specification.new do |spec|
  spec.name = "panda_core"
  spec.version = PandaDevTools::VERSION
  spec.authors = ["Panda Software Limited", "James Inman"]
  spec.email = ["bamboo@pandacms.io"]

  spec.summary = "Development tools for PandaCMS ecosystem"
  spec.description = "Shared development tools, configurations, and utilities for PandaCMS and its extensions"
  spec.homepage = "https://github.com/pandacms/panda_core"
  spec.license = "BSD-3-Clause"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir[
    "{app,config,db,lib}/**/*",
    "LICENSE",
    "Rakefile",
    "README.md",
    "lib/panda_core/templates/**/*"
  ]

  spec.add_dependency "standard", "~> 1.35"
  spec.add_dependency "standard-rails", "~> 1.0"
  spec.add_dependency "image_processing", "~> 1.2"
  spec.add_dependency "active_storage_validations"

  spec.add_dependency "thruster"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "factory_bot_rails"

  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-json"
  spec.add_development_dependency "rspec-github"
  spec.add_development_dependency "shoulda-matchers"
  spec.add_development_dependency "view_component"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "propshaft"
  spec.add_development_dependency "stimulus-rails"
  spec.add_development_dependency "turbo-rails"
  spec.add_development_dependency "generator_spec"

  # Development dependencies for CI workflow
  spec.add_development_dependency "bundler-audit" # For security checks
  spec.add_development_dependency "brakeman" # For security checks
  spec.add_development_dependency "standard" # For Ruby linting
  spec.add_development_dependency "erb_lint" # For ERB linting
  spec.add_development_dependency "yamllint" # For YAML linting
  spec.add_development_dependency "rspec-rails" # For testing
  spec.add_development_dependency "capybara" # For system tests
  spec.add_development_dependency "cuprite" # For headless Chrome testing
  spec.add_development_dependency "pg" # For PostgreSQL
  spec.add_development_dependency "redis" # For Redis
end
