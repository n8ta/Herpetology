class Photo < ApplicationRecord
  belongs_to :species
  mount_uploader :image_path, PhotoUploader

  validates :species_id, presence: true
  validates :image_path, presence: true

end
