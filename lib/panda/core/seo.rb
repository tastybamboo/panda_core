module Panda
  module Core
    module SEO
      extend ActiveSupport::Concern

      included do
        validates :meta_title, length: {maximum: 60}
        validates :meta_description, length: {maximum: 160}
      end

      def structured_data
        {
          "@context": "https://schema.org",
          "@type": self.class.name,
          name: title,
          description: meta_description,
          datePublished: created_at,
          dateModified: updated_at
        }
      end
    end
  end
end
