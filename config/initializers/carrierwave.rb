CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION'],
      endpoint: 'https://s3.amazonaws.com',
    }
    config.fog_directory = ENV['S3_BUCKET_NAME']
    config.fog_public = false # or true depending on your needs
  else
    config.storage = :file
    config.cache_dir = 'uploads/tmp'
  end
end
