# frozen_string_literal: true

require "rails"
require "dry-configurable"

module Panda
  module Core
    extend Dry::Configurable

    setting :user_class
    setting :authentication_providers, default: []
    setting :storage_provider, default: :active_storage
    setting :cache_store, default: :memory_store

    def self.root
      File.expand_path("../..", __FILE__)
    end
  end
end

require_relative "core/configuration"
require_relative "core/engine" if defined?(Rails)
