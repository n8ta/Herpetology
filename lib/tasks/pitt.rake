namespace :imports do

  desc "Import species + common names + photos from pitt.edu"
  task pitt: :environment do

    base_url = 'https://www.pitt.edu/~mcs2/herp/'
    success = 0
    total = 0
    genuses_found = 0
    text = IO.read(Rails.root.join('lib', 'tasks', 'assets', 'pitt.html'))
    html = Nokogiri::HTML(text)
    html.xpath(".//tr[@valign='top']").each do |specie|
      total += 1
      url = specie.xpath('.//a//@href').text
      common_name = specie.xpath('.//a').text.split("\n").join(" ").split(" ").join(" ")
      genus_species = specie.xpath('.//td').xpath('.//b').text.split("\n").join(" ").split(" ").join(" ")

      puts genus_species
      puts '  ' + common_name
      puts '  ' + url

      genus = genus_species.split(' ')[0]
      specie = genus_species.split(' ')[1]
      specie_m = nil
      begin
        success += 1
        specie_m = find_species(genus, specie)
      rescue
        begin
          gm = Genus.find_by(name: genus)
          raise if gm.nil?
          genuses_found += 1
          species_m = Species.new(name: specie, genus: gm)
          species_m.save
          species_m
        rescue
        end
      end
      next if specie_m.nil?

      unless common_name.nil?
        begin
        cnm = CommonName.new(name: common_name, species: specie_m)
        cnm.save!# common name model
        rescue
        end
      end

      response = HTTParty.get(base_url+url)
      next unless response.code == 200
      data = response.body

      file_path = Rails.root.join('tmp/pitt/' + SecureRandom.hex(50) + File.extname(base_url+url))

      File.open(file_path, "w") do |file|
        file.binmode
        file.write(data)
      end

      photo = Photo.new(species: specie_m)
      photo.image_path = Pathname.new(file_path).open
      photo.original_url = base_url+url
      photo.save!


      puts 'total: ' + total.to_s
      puts 'success: ' + success.to_s
      puts 'genuses: ' + genuses_found.to_s


    end

  end
end