namespace :imports do

  desc "Add photos to root taxons"
  task root_taxon_photos: :environment do
    # Add photos (not the normal photo model but a separate special photo for the root taxons)
    # to each root, they are in storage/#.[jpg|png]
    puts "Import root taxon photos..."
    (1..9).each do |num|
      txn = Taxon.find num
      ext = '.jpg'
      ext = '.png' if num == 8
      path = Rails.root.join('storage',num.to_s+ext)
      txn.photo = Pathname.new(path).open
      txn.save!
    end
  end
end

