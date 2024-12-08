module Panda
  module Core
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      namespace "panda:core:install"

      # Allow incompatible default types for Thor options
      def self.allow_incompatible_default_type!
        true
      end

      class_option :skip_migrations, type: :boolean, default: false,
        desc: "Skip migrations installation"
      class_option :orm, type: :string, default: "active_record",
        desc: "ORM to be used for migrations"

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def create_initializer
        template "initializer.rb", "config/initializers/panda_core.rb"
      end

      def mount_engine
        route 'mount Panda::Core::Engine => "/"'
      end

      def copy_migrations
        return if options[:skip_migrations]
        return unless options[:orm] == "active_record"

        migrations_path = File.expand_path("../../../../db/migrate", __dir__)
        Dir.glob("#{migrations_path}/*.rb").each do |migration|
          migration_template migration, "db/migrate/#{File.basename(migration)}"
        end
      end
    end
  end
end
