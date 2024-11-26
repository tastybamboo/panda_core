require "rails_helper"
require "generators/panda_core/install/install_generator"
require "generator_spec"

RSpec.describe PandaCore::Generators::InstallGenerator, type: :generator do
  include GeneratorSpec::TestCase
  tests PandaCore::Generators::InstallGenerator

  destination File.expand_path("../../../tmp", __FILE__)

  before(:all) do
    prepare_destination
  end

  before(:each) do
    # Ensure clean state for each test
    FileUtils.rm_rf(destination_root)
    FileUtils.mkdir_p(destination_root)

    # Setup basic Rails structure
    FileUtils.mkdir_p(File.join(destination_root, "config/initializers"))
    File.write(
      File.join(destination_root, "config/routes.rb"),
      "Rails.application.routes.draw do\nend\n"
    )
  end

  after(:all) do
    FileUtils.rm_rf(destination_root)
  end

  describe "installer" do
    context "basic installation" do
      before { run_generator }

      it "creates the initializer" do
        expect(File).to exist(File.join(destination_root, "config/initializers/panda_core.rb"))
      end

      it "mounts the engine in routes.rb" do
        routes_content = File.read(File.join(destination_root, "config/routes.rb"))
        expect(routes_content).to match(/mount PandaCore::Engine => '\//)
      end
    end

    context "when managing dependencies" do
      context "with Gemfile" do
        before do
          FileUtils.touch(File.join(destination_root, "Gemfile"))
          run_generator
        end

        it "adds new gems to the Gemfile" do
          gemfile_content = File.read(File.join(destination_root, "Gemfile"))
          expect(gemfile_content).to match(/gem 'panda_core'/)
          expect(gemfile_content).to match(/gem 'gem_name', '1.0.0'/)
          expect(gemfile_content).to match(/gem 'another_gem', git: 'https:\/\/github.com\/example\/another_gem'/)
        end
      end

      context "with gemspec" do
        before do
          File.write(File.join(destination_root, "test.gemspec"), "Gem::Specification.new do |spec|\nend\n")
          run_generator
        end

        it "adds new gems to the gemspec" do
          gemspec_content = File.read(File.join(destination_root, "test.gemspec"))
          expect(gemspec_content).to match(/spec.add_dependency "panda_core"/)
          expect(gemspec_content).to match(/spec.add_dependency "gem_name", "1.0.0"/)
        end
      end

      context "with no dependency file" do
        before { run_generator }

        it "creates a Gemfile and adds dependencies" do
          expect(File).to exist(File.join(destination_root, "Gemfile"))
          gemfile_content = File.read(File.join(destination_root, "Gemfile"))
          expect(gemfile_content).to match(/source 'https:\/\/rubygems.org'/)
          expect(gemfile_content).to match(/gem 'panda_core'/)
          expect(gemfile_content).to match(/gem 'gem_name', '1.0.0'/)
        end
      end
    end
  end
end
