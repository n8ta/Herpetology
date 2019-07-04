class TaxonHasOneCommonName < ActiveRecord::Migration[5.2]
  def up
    add_column :taxons, :common_name, :string
    CommonName.all.each do |cn|
      tx = cn.taxon
      tx.common_name = cn.name
      tx.save
    end
  end
  def down
    remove_column :taxons, :common_name
  end
end
