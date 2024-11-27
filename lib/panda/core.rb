# frozen_string_literal: true

require "dry-configurable"
require_relative "core/version"
require "panda/core/railtie"

module Panda
  module Core
    extend Dry::Configurable

    setting :user_class
    setting :authentication_providers, default: []
    setting :storage_provider, default: :active_storage
    setting :cache_store, default: :memory_store

    def self.root
      File.expand_path("..", __dir__)
    end
  end
end
