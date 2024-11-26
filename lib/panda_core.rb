# frozen_string_literal: true

require_relative "panda_core/version"

module PandaCore
  class Error < StandardError; end

  def self.root
    File.expand_path("..", __dir__)
  end
end
