CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws' # required
  config.fog_credentials = {
      provider: 'AWS', # required
      aws_access_key_id: ENV['aws_access_key_id'], # required unless using use_iam_profile
      aws_secret_access_key: ENV['aws_secret_access_key'], # required unless using use_iam_profile
      region: 'us-east-2', # optional, defaults to 'us-east-1'
      aws_bucket: ENV['aws_s3_bucketname']
      # use_iam_profile: true
      # host:                  's3.example.com',             # optional, defaults to nil
      # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.storage = :fog
  config.fog_directory = ENV['aws_s3_bucketname']

  config.fog_public = false # optional, defaults to true
  config.fog_attributes = {cache_control: "public, max-age=#{365.days.to_i}"} # optional, defaults to {}
end