class Tier1 < ApplicationRecord
  # Countries are t1.
  # t2/t3 are regions within countries and regions within those regions
  has_many :tier2s
  has_and_belongs_to_many :taxons

  def tier2s_with_6_photographed_species_for_taxon(taxon)

    tier2s.select {|t2| t2.taxons.species.select{|sp| sp.photos.any? and sp.root_taxon_id == taxon.id }.count > 6 }
  end
end
