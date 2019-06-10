class GeographySpeciesJoin < ActiveRecord::Migration[5.2]
  def up
    create_join_table :taxons, :tier1s
    create_join_table :taxons, :tier2s
    create_join_table :taxons, :tier3s
  end
end
