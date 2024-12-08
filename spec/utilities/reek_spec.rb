require "rails_helper"
require "reek"

RSpec.describe "Reek" do
  it "contains no code smells" do
    failures = []
    ruby_files = Dir.glob(Rails.root.join("app", "**", "*.rb"))

    # Use default configuration if no .reek.yml exists
    configuration = if File.exist?(Rails.root.join(".reek.yml"))
      Reek::Configuration::AppConfiguration.from_path(Rails.root.join(".reek.yml"))
    else
      Reek::Configuration::AppConfiguration.default
    end

    ruby_files.each do |file|
      # Create examiner with configuration
      examiner = Reek::Examiner.new(File.read(file), configuration: configuration)

      # Collect failures
      if examiner.smells.any?
        relative_path = Pathname.new(file).relative_path_from(Rails.root).to_s
        failures << {
          file: relative_path,
          smells: examiner.smells.map do |smell|
            {
              type: smell.smell_type,
              context: smell.context,
              message: smell.message,
              lines: smell.lines
            }
          end
        }
      end
    end

    # Report failures at the end
    if failures.any?
      puts "\nFound code smells in #{failures.length} files:"
      failures.each do |failure|
        puts "\n#{failure[:file]}:"
        failure[:smells].each do |smell|
          puts "  • #{smell[:type]}: #{smell[:message]}"
          puts "    on line(s) #{smell[:lines].join(", ")}"
          puts "    in #{smell[:context]}"
        end
      end

      # Fail the test
      aggregate_failures do
        failures.each do |failure|
          expect(failure).to be_nil, "Found code smells in #{failure[:file]}"
        end
      end
    end
  end
end
