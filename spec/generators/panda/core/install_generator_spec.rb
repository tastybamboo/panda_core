require "rails_helper"
require "generators/panda/core/install_generator"
require "support/generator_spec_helper"

RSpec.describe Panda::Core::InstallGenerator, type: :generator do
  before do
    FileUtils.mkdir_p(File.join(destination_root, "config"))
    File.write(
      File.join(destination_root, "config/routes.rb"),
      "Rails.application.routes.draw do\nend\n"
    )
  end

  it "creates the initializer file" do
    run_generator

    expect(file_exists?("config/initializers/panda_core.rb")).to be true
    content = read_file("config/initializers/panda_core.rb")
    expect(content).to match(/Panda::Core\.configure do \|config\|/)
    expect(content).to match(/# config\.user_class = "User"/)
    expect(content).to match(/# config\.storage_provider = :active_storage/)
    expect(content).to match(/# config\.cache_store = :memory_store/)
  end

  it "mounts the engine in routes.rb" do
    run_generator

    content = read_file("config/routes.rb")
    expect(content).to match(/mount Panda::Core::Engine => "\/"/i)
  end

  it "handles migrations properly" do
    allow(Rails).to receive(:root).and_return(Pathname.new(destination_root))
    expect(generator).to receive(:copy_migrations)
    run_generator
  end

  context "with existing initializer" do
    before do
      FileUtils.mkdir_p(File.join(destination_root, "config/initializers"))
      File.write(
        File.join(destination_root, "config/initializers/panda_core.rb"),
        <<~RUBY
          Panda::Core.configure do |config|
            config.user_class = "Admin"
          end
        RUBY
      )
    end

    it "overwrites the existing initializer" do
      run_generator

      content = read_file("config/initializers/panda_core.rb")
      expect(content).not_to match(/config\.user_class = "Admin"/)
      expect(content).to match(/# config\.user_class = "User"/)
    end
  end

  context "with existing routes" do
    before do
      File.write(
        File.join(destination_root, "config/routes.rb"),
        <<~RUBY
          Rails.application.routes.draw do
            resources :posts
          end
        RUBY
      )
    end

    it "adds engine mount without disturbing existing routes" do
      run_generator

      content = read_file("config/routes.rb")
      expect(content).to match(/resources :posts/)
      expect(content).to match(/mount Panda::Core::Engine => "\/"/i)
    end
  end
end
