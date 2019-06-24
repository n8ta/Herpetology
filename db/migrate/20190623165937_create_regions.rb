class CreateRegions < ActiveRecord::Migration[5.2]

  def change
    create_table :regions do |t|
      t.string :name
      t.references :region
    end
    create_join_table :regions, :taxons
    add_index :regions_taxons, [:taxon_id, :region_id], unique: true
  end



end