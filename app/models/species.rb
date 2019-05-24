class Species < ApplicationRecord
  belongs_to :genus
  has_many :common_names
  has_and_belongs_to_many :user_species_data

  validates :genus, presence: true
  validates :name, presence: true
end
