# frozen_string_literal: true

require_relative "lib/panda/core/version"

Gem::Specification.new do |spec|
  spec.name = "panda_core"
  spec.version = Panda::Core::VERSION
  spec.authors = ["Panda Software Limited", "James Inman"]
  spec.email = ["bamboo@pandacms.io"]

  spec.summary = "Core libraries and development tools for Panda Software projects"
  spec.description = "Shared development tools, configurations, and utilities for Panda CMS and its related projects"
  spec.homepage = "https://github.com/tastybamboo/panda_core"
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

  spec.add_dependency "activestorage-office-previewer"
  spec.add_dependency "annotaterb"
  spec.add_dependency "awesome_nested_set", "~> 3.7"
  spec.add_dependency "aws-sdk-s3", "~> 1"
  spec.add_dependency "better_errors"
  spec.add_dependency "binding_of_caller"
  spec.add_dependency "brakeman"
  spec.add_dependency "bullet"
  spec.add_dependency "bundler-audit"
  spec.add_dependency "capybara"
  spec.add_dependency "cuprite"
  spec.add_dependency "danger-reek"
  spec.add_dependency "danger-rubocop"
  spec.add_dependency "danger-simplecov_json"
  spec.add_dependency "danger-todoist"
  spec.add_dependency "danger"
  spec.add_dependency "dry-configurable", "~> 1"
  spec.add_dependency "erb_lint"
  spec.add_dependency "factory_bot_rails"
  spec.add_dependency "faker" # TODO: Remove depdedency by baking in OmniAuth mocks?
  spec.add_dependency "faraday-multipart", "~> 1"
  spec.add_dependency "faraday-retry", "~> 2"
  spec.add_dependency "faraday", "~> 2"
  spec.add_dependency "fasterer"
  spec.add_dependency "generator_spec"
  spec.add_dependency "image_processing", "~> 1.2"
  spec.add_dependency "importmap-rails", "~> 2"
  spec.add_dependency "listen"
  spec.add_dependency "lookbook", "~> 2"
  spec.add_dependency "omniauth-github", "~> 2.0" # TODO: Make this optional
  spec.add_dependency "omniauth-google-oauth2", "~> 1.1" # TODO: Make this optional
  spec.add_dependency "omniauth-microsoft_graph", "~> 2.0" # TODO: Make this optional
  spec.add_dependency "omniauth-rails_csrf_protection", "~> 1.0"
  spec.add_dependency "omniauth", "~> 2.1"
  spec.add_dependency "paper_trail", "~> 15"
  spec.add_dependency "pg", "~> 1.5"
  spec.add_dependency "propshaft", "~> 1.1"
  spec.add_dependency "puma"
  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "rake"
  spec.add_dependency "redis"
  spec.add_dependency "rspec-core", "~> 3.13"
  spec.add_dependency "rspec-github"
  spec.add_dependency "rspec-rails", "~> 7.1"
  spec.add_dependency "ruby-lsp"
  spec.add_dependency "shoulda-matchers"
  spec.add_dependency "silencer", "~> 2.0"
  spec.add_dependency "simplecov_json_formatter"
  spec.add_dependency "simplecov_lcov_formatter"
  spec.add_dependency "simplecov-json"
  spec.add_dependency "simplecov-lcov"
  spec.add_dependency "simplecov", "~> 0.22"
  spec.add_dependency "standard-rails"
  spec.add_dependency "standard"
  spec.add_dependency "stimulus-rails", "~> 1.3"
  spec.add_dependency "tailwindcss-rails", "~> 3"
  spec.add_dependency "turbo-rails", "~> 2.0"
  spec.add_dependency "view_component", "~> 3"
  spec.add_dependency "yamllint"
  spec.add_dependency "yard-activerecord"
end
