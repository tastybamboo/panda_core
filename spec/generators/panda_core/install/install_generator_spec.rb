require "rails_helper"
require "generators/panda_core/install/install_generator"
require "generator_spec"

RSpec.describe PandaCore::Generators::InstallGenerator, type: :generator do
  include FileUtils
  include GeneratorSpec::TestCase

  tests PandaCore::Generators::InstallGenerator
  destination File.expand_path("../../../tmp", __FILE__)

  before(:all) do
    prepare_destination
  end

  before do
    FileUtils.touch(File.join(destination_root, "Gemfile"))
    FileUtils.mkdir_p(File.join(destination_root, "config"))

    # Create a basic Rails routes file
    routes_rb = File.join(destination_root, "config/routes.rb")
    File.write(routes_rb, "Rails.application.routes.draw do\nend\n")
  end

  after(:all) do
    FileUtils.rm_rf(destination_root)
  end

  describe "installer" do
    before { run_generator }

    it "creates the initializer" do
      expect(File.exist?(File.join(destination_root, "config/initializers/panda_core.rb"))).to be true
    end

    it "mounts the engine in routes.rb" do
      routes_content = File.read(File.join(destination_root, "config/routes.rb"))
      expect(routes_content).to match(/mount PandaCore::Engine => '\//)
    end

    context "when managing dependencies" do
      it "adds new gems to the Gemfile" do
        gemfile_content = File.read(File.join(destination_root, "Gemfile"))
        expect(gemfile_content).to match(/gem 'panda_cms'/)
        expect(gemfile_content).to match(/gem 'panda_auth'/)
        expect(gemfile_content).to match(/gem 'devise'/)
        expect(gemfile_content).to match(/gem 'cancancan'/)
      end

      it "does not duplicate existing gems" do
        # Run generator again
        run_generator

        # Count occurrences of each gem
        gemfile_content = File.read(File.join(destination_root, "Gemfile"))
        expect(gemfile_content.scan("gem 'panda_cms'").count).to eq(1)
        expect(gemfile_content.scan("gem 'devise'").count).to eq(1)
      end
    end
  end
end
