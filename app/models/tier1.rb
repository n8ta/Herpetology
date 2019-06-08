class Tier1 < ApplicationRecord
  # Countries are t1.
  # t2/t3 are regions within countries and regions within those regions
  has_many :tier2s
  has_and_belongs_to_many :species
end
