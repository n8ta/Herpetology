namespace :imports do

  desc "Import photos from herpmapper"
  task herpmapper: :environment do
    base = '/herp/species/'
    done = 0
    Dir.entries(base).each do |species_dir|
      next if species_dir == "." or species_dir == ".."
      name = species_dir.titleize
      specie = Taxon.find_by(name: name.titleize)
      Dir.entries(base + species_dir).each do |photo_name|
        next if photo_name == "." or photo_name == ".."
        photo = Photo.new(taxon: specie)
        path = base + species_dir + '/' + photo_name
        photo.image_path = Pathname.new(path).open
        photo.save!
        done += 1
      end
      puts done
    end

  end
end