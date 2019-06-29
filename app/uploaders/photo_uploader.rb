require 'fog/aws'
class PhotoUploader < CarrierWave::Uploader::Base
  storage :fog
end
