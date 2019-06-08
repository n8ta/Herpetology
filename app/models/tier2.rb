class Tier2 < ApplicationRecord
  belongs_to :tier1
  has_many :tier3s
  has_and_belongs_to_many :species
end
