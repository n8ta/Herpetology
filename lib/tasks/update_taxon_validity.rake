namespace :maintenance do
  desc "Update valid bool on taxon species models"
  task update_taxon_validity: :environment do
    puts "Starting maintence: update taxon validity"
    puts Taxon.all.size
    x = 0
    Taxon.all.each do |txn|
      puts x if x%1000 == 0
      x+=1
      if txn.photos.where(dead: false).any?
        txn.photographed = true

      else
        txn.photographed = false
      end
      txn.save
    end
  end
end
