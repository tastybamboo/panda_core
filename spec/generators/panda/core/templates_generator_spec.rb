require "rails_helper"
require_relative "../../../../lib/generators/panda/core/templates_generator"
require "generator_spec"

RSpec.describe Panda::Core::Generators::TemplatesGenerator do
  include FileUtils
  include GeneratorSpec::TestCase

  destination File.expand_path("../../../../tmp", __FILE__)

  let(:template_files) do
    template_root = described_class.source_root
    Dir.glob(File.join(template_root, "**/{.*,*}"), File::FNM_DOTMATCH)
      .reject { |f| File.directory?(f) }
      .reject { |f| File.basename(f) == "." || File.basename(f) == ".." }
      .map { |f| Pathname.new(f).relative_path_from(Pathname.new(template_root)).to_s }
  end

  let(:missing_file) { ".missing_config.yml" }

  let(:expected_config_files) do
    [
      ".standard.yml",
      ".gitignore",
      ".erb_lint.yml",
      ".yamllint"
    ]
  end

  before(:all) do
    prepare_destination
  end

  after(:all) do
    FileUtils.rm_rf(destination_root)
  end

  it "copies all template files" do
    run_generator

    template_files.each do |file|
      # Check if file exists in source first
      source_path = File.join(described_class.source_root, file)
      expect(File).to exist(source_path), "Expected #{file} to exist in source: #{source_path}"

      # Then check if it was copied to destination
      dest_path = File.join(destination_root, file)
      # Create directory if it doesn't exist, ignore if it does
      begin
        FileUtils.mkdir_p(File.dirname(dest_path))
      rescue Errno::EEXIST
        # Directory already exists, that's fine
      end
      expect(File).to exist(dest_path), "Expected #{file} to exist in destination: #{dest_path}"
    end
  end

  it "copies all configuration files" do
    # Get absolute paths and verify template directory
    template_root = File.expand_path(described_class.source_root)
    puts "Template root: #{template_root}"
    puts "Destination root: #{destination_root}"

    # Check source files before running generator
    expected_config_files.each do |file|
      source_path = File.join(template_root, file)
      # puts "Source file check:"
      # puts "  Path: #{source_path}"
      # puts "  Exists?: #{File.exist?(source_path)}"
      # puts "  Absolute?: #{File.absolute_path?(source_path)}"

      expect(File).to exist(source_path),
        "Expected #{file} to exist in #{source_path}"
    end

    run_generator

    # Check destination files after running generator
    expected_config_files.each do |file|
      dest_path = File.join(destination_root, file)
      # puts "Destination file check:"
      # puts "  Path: #{dest_path}"
      # puts "  Exists?: #{File.exist?(dest_path)}"
      # puts "  Absolute?: #{File.absolute_path?(dest_path)}"

      expect(File).to exist(dest_path),
        "Expected #{file} to exist in #{destination_root}"
    end
  end

  it "raises an error when trying to copy a missing file" do
    generator = Panda::Core::Generators::TemplatesGenerator.new
    template_root = described_class.source_root
    missing_file_path = File.join(template_root, missing_file)

    # Mock the Dir.glob to return our missing file with full path
    allow(Dir).to receive(:glob)
      .with(File.join(described_class.source_root, "**/{.*,*}"), File::FNM_DOTMATCH)
      .and_return([missing_file_path])

    # Stub File.directory? to return false for the missing file
    allow(File).to receive(:directory?).with(missing_file_path).and_return(false)

    # Stub File.basename to work normally
    allow(File).to receive(:basename).and_call_original

    # Stub the copy_file method to raise an error for our missing file
    allow(generator).to receive(:copy_file)
      .with(missing_file)
      .and_raise(Thor::Error, "Source file not found: #{missing_file}")

    expect {
      generator.copy_templates
    }.to raise_error(Thor::Error, /Source file not found: .*#{missing_file}/)
  end
end
