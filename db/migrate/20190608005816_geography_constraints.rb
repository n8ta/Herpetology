class GeographyConstraints < ActiveRecord::Migration[5.2]
  def change
    add_index :taxons_tier1s, [:taxon_id, :tier1_id], unique: true
    add_index :taxons_tier2s, [:taxon_id, :tier2_id], unique: true
    add_index :taxons_tier3s, [:taxon_id, :tier3_id], unique: true

    [Tier1,Tier2,Tier3].each do |tier|
      tier.all.each do |area|
        area.species = area.species.uniq
      end
    end

  end
end
