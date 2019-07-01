namespace :maintenance do
  desc "Download regions from herpmapper"
  task update_regions_root_taxons_table: :environment do
    puts "Maintence: update regions for root taxons"
    puts "Taxons"+Taxon.roots.count.to_s
    x = 0
    Taxon.all.roots.each do |txn|
      puts x
      begin
        txn.valid_regions << Region.all.includes(:taxons).select {|ct| ct.taxons.species.includes(:photos).where(root_taxon_id: txn.id).select{|sp| sp.photos.size > 0 }.size >5}
      rescue
      end
      x+=1
    end
  end
end
