module Panda
  module Core
    class Configuration
      attr_accessor :user_class,
        :storage_provider,
        :cache_store,
        :parent_controller,
        :parent_mailer,
        :mailer_sender,
        :mailer_default_url_options,
        :session_token_cookie

      def initialize
        @storage_provider = :active_storage
        @cache_store = :memory_store
        @parent_controller = "ActionController::API"
        @parent_mailer = "ActionMailer::Base"
        @mailer_sender = "support@example.com"
        @mailer_default_url_options = {host: "localhost:3000"}
        @session_token_cookie = :session_token
      end
    end

    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end

      def reset_configuration!
        @configuration = Configuration.new
      end
    end
  end
end
