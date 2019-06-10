class TaxonHasRootTaxon < ActiveRecord::Migration[5.2]
  def up
    add_column :taxons, :root_taxon_id, :integer
    add_foreign_key :taxons, :taxons, column: :root_taxon_id

    # Taxon.all.each do |txn|
    #   txn.root_taxon = txn.root
    # end
  end

  def down
    remove_foreign_key :taxons, :taxons, column: :root_taxon_id
    remove_column :taxons, :root_taxon_id
  end
end
