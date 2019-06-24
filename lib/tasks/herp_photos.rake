namespace :imports do

  desc "Import photos from herpmapper"
  task herp_photos: :environment do
    base = '/Users/n8ta/Desktop/herp/species/'
    done = 0
    Dir.entries(base).each do |species_dir|
      next if species_dir == "." or species_dir == ".."
      name = species_dir.titleize
      begin
        specie = Taxon.find_by(name: name)
        Dir.entries(base + species_dir).each do |photo_name|
          begin
            next if photo_name == "." or photo_name == ".."
            photo = Photo.new(taxon: specie)
            path = base + species_dir + '/' + photo_name
            photo.image_path = Pathname.new(path).open
            photo.save!
            done += 1
          rescue
            puts "Failed on " + species_dir.to_s + " " + photo_name.to_s
            next
          end
        end
        puts done
      rescue error
        puts "Failed on: " + species_dir.to_s
        next
      end
    end

  end
end