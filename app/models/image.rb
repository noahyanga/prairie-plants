class Image < ApplicationRecord
  belongs_to :product
    
  validates :image_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }
end
