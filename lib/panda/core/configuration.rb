module Panda
  module Core
    class Configuration
      attr_accessor :user_class,
        :authentication_providers,
        :storage_provider,
        :cache_store

      def initialize
        @authentication_providers = []
        @storage_provider = :active_storage
        @cache_store = :memory_store
      end
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
