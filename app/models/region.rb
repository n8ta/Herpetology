class Region < ApplicationRecord
  mount_uploader :image_path, RegionUploader
  has_and_belongs_to_many :species
end
