class SingleSpeciesRegionPair < ActiveRecord::Migration[5.2]
  def change
    add_index :regions_species, [:region_id, :species_id], unique: true
  end
end
