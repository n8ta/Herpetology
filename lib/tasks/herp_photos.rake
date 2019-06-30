namespace :imports do

  desc "Import photos from herpmapper"
  task herp_photos: :environment do
    done = 0
    puts "Staring import of herp mapper photos"

    q = Queue.new
    base = '/Users/n8ta/Desktop/herp2/species/'

    Dir.entries(base).each do |species_dir|
      q << species_dir
    end


    def handle_dir(species_dir)
      base = '/Users/n8ta/Desktop/herp2/species/'
      return if species_dir == "." or species_dir == ".." or species_dir == ".DS_Store"
      name = species_dir.titleize
      begin
        specie = Taxon.find_by(name: name)
        Dir.entries(base + species_dir).each do |photo_name|
          begin
            next if photo_name == "." or photo_name == ".." or species_dir == ".DS_Store"

            photo = Photo.new(taxon: specie)


            if photo_name[0] == 'a'
              photo.dead = false
            elsif photo_name[1] == 'd'
              photo.dead = true
            end

            path = base + species_dir + '/' + photo_name
            photo.image_path = Pathname.new(path).open
            photo.save!
          rescue => e
            puts e
            logger.error e.message
            logger.error e.backtrace.join("\n")
            puts "Failed on " + species_dir.to_s + " " + photo_name.to_s
            next
          end
        end
      rescue error
        puts "Failed on: " + species_dir.to_s
        return
      end
    end


    threads = []
    for x in 0..10
      threads << Thread.new {
        while q.length != 0
          species_dir = q.pop
          puts "done: "+done.to_s
          begin
            handle_dir(species_dir)
            done += 1
          rescue
            q << page
          end
        end
      }
    end

    threads.each do |thr|
      thr.join()
    end



  end
end