class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog # Use fog for S3 storage in production
  else
    storage :file # Use local file storage for development and test
  end

  # Override the directory where uploaded files will be stored:
  def store_dir
    "uploads/product/image/#{model.id}"
  end

  # Process files as they are uploaded:
  version :thumb do
    process resize_to_fit: [400, 400]
  end

  # Add an allowlist of extensions which are allowed to be uploaded:
  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
