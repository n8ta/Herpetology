class RegionTaxonFks < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :regions_taxons, :regions
    add_foreign_key :regions_taxons, :taxons
  end
end
