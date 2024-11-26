module PandaCore
  module Media
    extend ActiveSupport::Concern

    included do
      has_one_attached :featured_image
      has_many_attached :attachments
      
      validates :featured_image, content_type: [:png, :jpg, :jpeg],
                               size: { less_than: 5.megabytes }
    end

    def image_url(variant: nil)
      return nil unless featured_image.attached?
      
      case variant
      when :thumbnail
        featured_image.variant(resize_to_fill: [200, 200]).processed
      when :medium
        featured_image.variant(resize_to_fill: [400, 400]).processed
      else
        featured_image
      end
    end
  end
end 
