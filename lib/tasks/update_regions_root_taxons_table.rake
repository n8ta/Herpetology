namespace :maintence do
  desc "Download regions from herpmapper"
  task update_regions_root_taxons_table: :environment do
    puts "Root taxons"+Taxon.roots.count.to_s
    x = 0
    states = []
    countries = []
    Region.countries.each do |rg|
      states = states + rg.regions.to_a
    end
    Taxon.all.roots.each do |txn|
      puts x

      begin
        txn.valid_regions << Region.countries.select {|ct| ct.taxons.species.where(root_taxon_id: txn.id).select{|sp| sp.photos.size > 0 }.size >5}
      rescue
      end
      txn.valid_regions << states.select {|ct| ct.taxons.species.where(root_taxon_id: txn.id).select{|sp| sp.photos.size > 0 }.size >5}
      x+=1
    end
  end
end
