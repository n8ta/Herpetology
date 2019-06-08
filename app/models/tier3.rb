class Tier3 < ApplicationRecord
  belongs_to :tier2
  has_and_belongs_to_many :species
end
