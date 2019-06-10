class Tier1 < ApplicationRecord
  # Countries are t1.
  # t2/t3 are regions within countries and regions within those regions
  has_many :tier2s
  has_and_belongs_to_many :taxons

  def tier2s_with_6_photographed_species
    tier2s.select {|t2| t2.taxons.species.includes(:photos).where.not(photos: {id: nil}).length > 6 }
  end
end
