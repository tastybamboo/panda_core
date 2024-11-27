require "rails/railtie"

module Panda
  module Core
    class Railtie < Rails::Railtie
      generators do
        require_relative "generators/install/install_generator"
        require_relative "generators/templates_generator"
      end
    end
  end
end
