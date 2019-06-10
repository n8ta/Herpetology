class SingleUserSpeciesPair < ActiveRecord::Migration[5.2]
  def up
    add_index :user_taxon_data, [:user_id, :taxon_id], unique: true
  end
  def down
    remove_index :user_taxon_data, [:user_id, :taxon_id]
  end
end
