require "rails_helper"

RSpec.describe Panda::Core do
  describe "configuration" do
    before do
      described_class.reset_configuration!
    end

    after do
      described_class.reset_configuration!
    end

    it "has default values" do
      config = described_class.configuration
      expect(config.storage_provider).to eq(:active_storage)
      expect(config.cache_store).to eq(:memory_store)
      expect(config.user_class).to be_nil
      expect(config.parent_controller).to eq("ActionController::API")
      expect(config.parent_mailer).to eq("ActionMailer::Base")
      expect(config.mailer_sender).to eq("support@example.com")
      expect(config.mailer_default_url_options).to eq({host: "localhost:3000"})
      expect(config.session_token_cookie).to eq(:session_token)
    end

    it "allows setting configuration values" do
      described_class.configure do |config|
        config.user_class = "User"
        config.storage_provider = :disk
        config.cache_store = :redis_store
        config.parent_controller = "ApplicationController"
        config.parent_mailer = "CustomMailer"
        config.mailer_sender = "test@example.com"
        config.mailer_default_url_options = {host: "example.com"}
        config.session_token_cookie = :custom_token
      end

      config = described_class.configuration
      expect(config.user_class).to eq("User")
      expect(config.storage_provider).to eq(:disk)
      expect(config.cache_store).to eq(:redis_store)
      expect(config.parent_controller).to eq("ApplicationController")
      expect(config.parent_mailer).to eq("CustomMailer")
      expect(config.mailer_sender).to eq("test@example.com")
      expect(config.mailer_default_url_options).to eq({host: "example.com"})
      expect(config.session_token_cookie).to eq(:custom_token)
    end
  end
end
