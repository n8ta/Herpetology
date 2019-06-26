namespace :maintence do
  desc "Update valid bool on taxon species models"
  task update_taxon_validity: :environment do
    puts "Size:"
    puts Taxon.all.size
    x = 0
    Taxon.all.each do |txn|
      puts x
      x+=1
      puts "txn photos:"
      puts txn.inspect
      puts txn.photos.inspect
      if txn.photos.any?
        txn.photograped = true
        txn.save
      end
    end
  end
end
