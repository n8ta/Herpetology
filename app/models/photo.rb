class Photo < ApplicationRecord
  belongs_to :taxon
  mount_uploader :image_path, PhotoUploader

  validates :taxon_id, presence: true
  validates :image_path, presence: true
end
