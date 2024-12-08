module Panda
  module Core
    module OAuthProviders
      def self.setup
        providers = []

        begin
          require "omniauth-github"
          providers << :github
        rescue LoadError
          # GitHub OAuth functionality not available
        end

        begin
          require "omniauth-google-oauth2"
          providers << :google_oauth2
        rescue LoadError
          # Google OAuth functionality not available
        end

        begin
          require "omniauth-microsoft_graph"
          providers << :microsoft_graph
        rescue LoadError
          # Microsoft OAuth functionality not available
        end

        providers
      end
    end
  end
end
