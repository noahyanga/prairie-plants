# class Image < ApplicationRecord
#   belongs_to :product
#   mount_uploader :file, ImageUploader

#   # Validate for web URLs and local file paths
#   validates :file, presence: true

#   # def valid_image_file_extension
#   #   if image_file.attached?
#   #     unless image_file.filename.to_s.match(/\.(jpg|jpeg|png|gif|ico)\z/i)
#   #       errors.add(:image_file, "must be a valid image file (jpg, jpeg, png, gif, ico)")
#   #     end
#   #   end
#   # end

#   # # Check if the image file is attached
#   # def valid_image?
#   #   image_file.attached? || image_url.present?
#   # end
# end
