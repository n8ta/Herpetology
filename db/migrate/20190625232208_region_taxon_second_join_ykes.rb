class RegionTaxonSecondJoinYkes < ActiveRecord::Migration[5.2]
  def up
    create_table 'regions_root_taxons' do |t|
      t.references :region, foreign_key: true
      t.references :taxon, foreign_key: true
    end
    add_index 'regions_root_taxons', [:taxon_id, :region_id], unique: true
    Rake::Task['maintenance:update_regions_root_taxons_table'].invoke
  end


  def down
    drop_table 'regions_root_taxons'
  end
end
