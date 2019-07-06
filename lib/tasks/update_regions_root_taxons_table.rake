namespace :maintenance do
  desc "Download regions from herpmapper"
  task update_regions_root_taxons_table: :environment do
    puts "Maintence: update regions for root taxons"
    puts "Taxons"+Taxon.roots.count.to_s
    x = 0
    Taxon.all.roots.each do |txn|
      puts x
      begin
        txn.valid_regions = []
        txn.valid_regions << Region.all.select { |ct| ct.taxons.species.where(root_taxon_id: txn.id, photographed: true).size > 5 }
      rescue
      end
      x+=1
    end
  end
end
