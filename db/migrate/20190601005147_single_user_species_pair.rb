class SingleUserSpeciesPair < ActiveRecord::Migration[5.2]
  def up
    add_index :user_species_data, [:user_id, :species_id], unique: true
  end
  def down
    remove_index :user_species_data, [:user_id, :species_id]
  end
end
