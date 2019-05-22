class JoinSpeciesAndRegion < ActiveRecord::Migration[5.2]
  def up
    create_join_table :species, :regions
  end
  def down
    drop_join_table :species, :regions
  end
end
