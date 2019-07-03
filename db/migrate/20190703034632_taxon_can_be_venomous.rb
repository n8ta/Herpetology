class TaxonCanBeVenomous < ActiveRecord::Migration[5.2]
  def change
    add_column :taxons, :venomous, :boolean
  end
end
