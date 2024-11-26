module PandaCore
  module Sluggable
    extend ActiveSupport::Concern

    included do
      before_validation :generate_slug
      validates :slug, presence: true, uniqueness: true
    end

    private

    def generate_slug
      self.slug ||= title.to_s.parameterize
    end
  end
end 
