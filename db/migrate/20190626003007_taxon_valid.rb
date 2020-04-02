class TaxonValid < ActiveRecord::Migration[5.2]
  def up
    add_column :taxons, :photograped, :boolean, default: false, null: false
    Rake::Task['maintenance:update_taxon_validity'].invoke
  end
  def down
    remove_column :taxons, :photograped
  end


end
