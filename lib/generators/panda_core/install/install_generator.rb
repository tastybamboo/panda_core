require "rails/generators"

module PandaCore
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Installs PandaCore and its dependencies"

      def install_dependencies
        manage_gem_dependencies
      end

      def install_initializer
        template "initializer.rb", File.join(destination_root, "config/initializers/panda_core.rb")
      end

      def mount_engine
        inject_into_file File.join(destination_root, "config/routes.rb"),
          "  mount PandaCore::Engine => '/'\n",
          before: /^end/
      end

      private

      def gems_to_add
        {
          "panda_core" => {},
          "gem_name" => {version: "1.0.0"},
          "another_gem" => {git: "https://github.com/example/another_gem"}
          # Add other gems as needed
        }
      end

      def manage_gem_dependencies
        if File.exist?(File.join(destination_root, "Gemfile"))
          manage_gemfile_dependencies
        elsif Dir.glob(File.join(destination_root, "*.gemspec")).any?
          manage_gemspec_dependencies
        else
          create_file File.join(destination_root, "Gemfile") do
            content = "source 'https://rubygems.org'\n\n"
            gems_to_add.each do |gem_name, options|
              content << if options[:git]
                "gem '#{gem_name}', git: '#{options[:git]}'\n"
              elsif options[:version]
                "gem '#{gem_name}', '#{options[:version]}'\n"
              else
                "gem '#{gem_name}'\n"
              end
            end
            content
          end
        end
      end

      def manage_gemfile_dependencies
        gemfile_content = File.read(File.join(destination_root, "Gemfile"))

        gems_to_add.each do |gem_name, options|
          next if should_skip_gem?(gemfile_content, gem_name, options)

          if options[:git]
            append_to_file File.join(destination_root, "Gemfile"), "\ngem '#{gem_name}', git: '#{options[:git]}'"
          elsif options[:version]
            append_to_file File.join(destination_root, "Gemfile"), "\ngem '#{gem_name}', '#{options[:version]}'"
          else
            append_to_file File.join(destination_root, "Gemfile"), "\ngem '#{gem_name}'"
          end
        end
      end

      def manage_gemspec_dependencies
        gemspec_file = Dir.glob(File.join(destination_root, "*.gemspec")).first

        if File.exist?(gemspec_file)
          content = File.read(gemspec_file)

          gems_to_add.each do |gem_name, options|
            next if content.include?("spec.add_dependency \"#{gem_name}\"")

            dependency_line = if options[:version]
              "  spec.add_dependency \"#{gem_name}\", \"#{options[:version]}\"\n"
            else
              "  spec.add_dependency \"#{gem_name}\"\n"
            end

            # Insert before the last 'end'
            gsub_file gemspec_file, /end\s*\z/ do |match|
              "#{dependency_line}#{match}"
            end
          end
        end
      end

      def should_skip_gem?(gemfile_content, gem_name, new_options)
        gemfile_content.match?(/gem ['"]#{gem_name}['"]/)
      end
    end
  end
end
