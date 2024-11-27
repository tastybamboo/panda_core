require "rails/generators"

module Panda
  module Core
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path("templates", __dir__)

        desc "Installs Panda::Core and its dependencies"

        def install_dependencies
          manage_gem_dependencies
        end

        def install_initializer
          initializer_path = File.join(destination_root, "config/initializers/panda/core.rb")

          if File.exist?(initializer_path)
            append_missing_configurations(initializer_path)
          else
            begin
              FileUtils.mkdir_p(File.dirname(initializer_path))
            rescue Errno::EEXIST
              # Directory already exists, that's fine
            end
            template "initializer.rb", initializer_path
          end
        end

        # def mount_engine
        #   inject_into_file File.join(destination_root, "config/routes.rb"),
        #     "  mount Panda::Core::Engine => '/'\n",
        #     before: /^end/
        # end

        private

        def gems_to_add
          {
            "panda_core" => {}
            # "gem_name" => {version: "1.0.0"},
            # "another_gem" => {git: "https://github.com/example/another_gem"}
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

        def append_missing_configurations(path)
          content = File.read(path)
          missing_configs = []

          unless content.include?("config.user_class")
            missing_configs << "  # Set the user class for authentication (e.g., 'User')"
            missing_configs << "  # config.user_class = nil"
          end

          unless content.include?("config.authentication_providers")
            missing_configs << "  # Configure authentication providers (e.g., [:devise, :jwt])"
            missing_configs << "  # config.authentication_providers = []"
          end

          unless content.include?("config.storage_provider")
            missing_configs << "  # Set the storage provider (:active_storage or :aws)"
            missing_configs << "  # config.storage_provider = :active_storage"
          end

          unless content.include?("config.cache_store")
            missing_configs << "  # Set the cache store (:memory_store, :redis_cache_store, etc.)"
            missing_configs << "  # config.cache_store = :memory_store"
          end

          if missing_configs.any?
            inject_into_file path, before: /^end/ do
              "\n#{missing_configs.join("\n")}\n"
            end
          end
        end
      end
    end
  end
end
