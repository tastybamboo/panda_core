# frozen_string_literal: true

require_relative "core/version"
require "panda/core/railtie"

module Panda
  module Core
    class Error < StandardError; end

    def self.root
      File.expand_path("..", __dir__)
    end
  end
end
