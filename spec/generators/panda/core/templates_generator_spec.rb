require "rails_helper"
require_relative "../../../../lib/panda/core/generators/templates_generator"
require "generator_spec"

RSpec.describe Panda::Core::Generators::TemplatesGenerator do
  include FileUtils
  include GeneratorSpec::TestCase

  destination File.expand_path("../../../tmp", __FILE__)

  let(:template_files) do
    template_root = described_class.source_root
    Dir.glob(File.join(template_root, "**/*"), File::FNM_DOTMATCH)
      .reject { |f| File.directory?(f) }
      .reject { |f| File.basename(f) == "." || File.basename(f) == ".." }
      .map { |f| Pathname.new(f).relative_path_from(Pathname.new(template_root)).to_s }
  end

  let(:missing_file) { ".lefthook.yml" }

  before(:all) do
    prepare_destination
  end

  after(:all) do
    FileUtils.rm_rf(destination_root)
  end

  it "copies all template files" do
    run_generator

    template_files.each do |file|
      source_path = File.join(destination_root, file)
      expect(File).to exist(source_path), "Expected #{file} to exist in #{source_path}"
    end
  end

  it "raises an error when trying to copy a missing file" do
    template_root = described_class.source_root

    # Allow Dir.glob to return all files including the missing one
    allow(Dir).to receive(:glob).with(any_args).and_return(
      template_files.map { |f| File.join(template_root, f) } +
      [File.join(template_root, missing_file)]
    )

    # Stub File.directory? to return false for all files
    allow(File).to receive(:directory?).and_return(false)

    # Stub File.basename to work normally
    allow(File).to receive(:basename).and_call_original

    # Stub File.exist? to return true for template files and false for missing file
    allow(File).to receive(:exist?).and_return(false)
    template_files.each do |file|
      source_file = File.join(template_root, file)
      allow(File).to receive(:exist?).with(source_file).and_return(true)
    end

    # Stub FileUtils.mkdir_p to do nothing
    allow(FileUtils).to receive(:mkdir_p)

    # Stub Thor's copy_file to raise error for missing file
    generator = Panda::Core::Generators::TemplatesGenerator.new
    allow(generator).to receive(:copy_file).and_call_original
    allow(generator).to receive(:copy_file)
      .with(File.join(template_root, missing_file), missing_file, force: true)
      .and_raise(Thor::Error, "Source file not found: #{missing_file}")

    expect {
      generator.copy_templates
    }.to raise_error(Thor::Error, /Source file not found: .*#{missing_file}/)
  end
end
