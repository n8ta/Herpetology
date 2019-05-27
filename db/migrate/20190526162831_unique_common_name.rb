class UniqueCommonName < ActiveRecord::Migration[5.2]
  def change
    add_index :common_names, [:name, :species_id], unique: true
  end
end