class GeographySpeciesJoin < ActiveRecord::Migration[5.2]
  def up
    create_join_table :species, :tier1s
    create_join_table :species, :tier2s
    create_join_table :species, :tier3s
  end
end
