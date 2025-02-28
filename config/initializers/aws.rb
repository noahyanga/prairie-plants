if ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present? && ENV['AWS_REGION'].present?
  Fog::Storage.new(
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_REGION']
  )
else
  Rails.logger.warn('AWS credentials are missing. Fog Storage will not be initialized.')
  nil # Prevent raising an error
end
