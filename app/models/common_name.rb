class CommonName < ApplicationRecord
  belongs_to :species
  validates :name, presence: true
  validates :species_id, presence: true
end
