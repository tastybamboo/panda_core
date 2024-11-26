require "rails/generators/base"
require "rails/generators/actions"
require "fileutils"

module PandaCore
  class TemplatesGenerator < Rails::Generators::Base
    include Rails::Generators::Actions
    source_root File.expand_path("templates", __dir__)

    desc "Copies shared configuration templates from panda_core"

    def copy_templates
      template_root = self.class.source_root
      files = Dir.glob(File.join(template_root, "**/*"), File::FNM_DOTMATCH)

      files.each do |file|
        next if File.directory?(file)
        next if File.basename(file) == "." || File.basename(file) == ".."

        relative_path = Pathname.new(file).relative_path_from(Pathname.new(template_root)).to_s

        # Add error handling for missing source files
        unless File.exist?(file)
          raise Thor::Error, "Source file not found: #{file}"
        end

        dest_dir = File.dirname(File.join(destination_root, relative_path))
        FileUtils.mkdir_p(dest_dir) unless File.directory?(dest_dir)

        copy_file file, relative_path, force: true
      end
    end
  end
end
