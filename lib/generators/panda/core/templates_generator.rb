require "rails/generators"
require "fileutils"
require "pathname"

module Panda
  module Core
    module Generators
      class TemplatesGenerator < Rails::Generators::Base
        include Thor::Actions

        desc "Copies shared configuration templates from panda_core"

        source_root File.expand_path("templates", __dir__)

        def copy_templates
          Dir.glob(File.join(self.class.source_root, "**/{.*,*}"), File::FNM_DOTMATCH).each do |file|
            next if File.directory?(file)
            next if File.basename(file) == "." || File.basename(file) == ".."

            relative_path = Pathname.new(file).relative_path_from(Pathname.new(self.class.source_root)).to_s
            copy_file relative_path
          end
        end
      end
    end
  end
end
