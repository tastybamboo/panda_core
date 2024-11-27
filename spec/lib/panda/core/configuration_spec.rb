require "rails_helper"

RSpec.describe Panda::Core do
  describe "configuration" do
    after do
      # Reset configuration after each test
      described_class.config.user_class = nil
      described_class.config.authentication_providers = []
      described_class.config.storage_provider = :active_storage
      described_class.config.cache_store = :memory_store
    end

    it "allows setting configuration values" do
      described_class.configure do |config|
        config.user_class = "User"
        config.authentication_providers = [:devise]
        config.storage_provider = :aws
        config.cache_store = :redis_cache_store
      end

      expect(described_class.config.user_class).to eq("User")
      expect(described_class.config.authentication_providers).to eq([:devise])
      expect(described_class.config.storage_provider).to eq(:aws)
      expect(described_class.config.cache_store).to eq(:redis_cache_store)
    end

    it "maintains default values when not configured" do
      expect(described_class.config.authentication_providers).to eq([])
      expect(described_class.config.storage_provider).to eq(:active_storage)
      expect(described_class.config.cache_store).to eq(:memory_store)
      expect(described_class.config.user_class).to be_nil
    end
  end
end
