class TaxonHasPhoto < ActiveRecord::Migration[5.2]
  def change
    add_column :taxons, :photo, :string, optional: true
  end
end
