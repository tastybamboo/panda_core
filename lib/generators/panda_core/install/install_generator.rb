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
        template "initializer.rb", "config/initializers/panda_core.rb"
      end

      def mount_engine
        route "mount PandaCore::Engine => '/'"
      end

      private

      def gems_to_add
        {
          "panda_cms" => {},
          "panda_auth" => {},
          "devise" => {},
          "cancancan" => {},
          "gem_name" => {version: "1.0.0"},
          "another_gem" => {git: "https://github.com/example/another_gem"}
          # Add other gems as needed
        }
      end

      def manage_gem_dependencies
        gemfile_content = File.read("Gemfile")

        gems_to_add.each do |gem_name, options|
          next if should_skip_gem?(gemfile_content, gem_name, options)

          if options[:git]
            append_to_file "Gemfile", "\ngem '#{gem_name}', git: '#{options[:git]}'"
          elsif options[:version]
            append_to_file "Gemfile", "\ngem '#{gem_name}', '#{options[:version]}'"
          else
            append_to_file "Gemfile", "\ngem '#{gem_name}'"
          end
        end
      end

      def should_skip_gem?(gemfile_content, gem_name, new_options)
        gemfile_content.match?(/gem ['"]#{gem_name}['"]/)
      end
    end
  end
end
