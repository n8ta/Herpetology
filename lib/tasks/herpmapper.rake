def find_species(genus_txt, species_txt)
  ### Search models for the genus / species pair
  genus = Genus.where('lower(name) = ?', genus_txt.downcase).first
  species = genus.species.find_by('lower(name) = ?', species_txt.downcase)

  if species.nil?
    puts '  failed on: ' + genus_txt + ' ' + species_txt
    raise
  end
  return species
end

namespace :imports do

  desc "Import photos from herpmapper"
  task herpmapper: :environment do

    page = 1
    response = HTTParty.get('https://www.herpmapper.org/records?taxon=Serpentes&deceased=no&p=' + page.to_s)
    while (response.code == 200) and (page < 925)
      html = Nokogiri::HTML(response.body)
      table = html.xpath(".//div[@id='content']").xpath('.//table').xpath(".//tr").each do |row|
        begin
          links = row.xpath('.//a')
          sci_name = links[2].text.split(" ").join(" ").split("\n").join(" ")
          split = sci_name.split(" ")
          species_name = split[1].titleize
          genus_name = split[0].titleize
          species_model = find_species(genus_name, species_name)
          voucher_number = row.xpath(".//td[@width='78']").xpath(".//img/@src").text.split("voucher/")[1].split("/")[0]
          # puts "voucher:: "+voucher_number
          puts " --- new ---"
          puts "vnumber: " + voucher_number.to_s
          puts "species: " + species_model.inspect

          full_image_path = "https://www.herpmapper.org/voucher/" + voucher_number + "/full.jpg"

          image_response = HTTParty.get(full_image_path)
          next unless image_response.code == 200
          data = image_response.body

          file_path = Rails.root.join('tmp/herpmapper/' + SecureRandom.hex(50) + ".jpg")

          File.open(file_path, "w") do |file|
            file.binmode
            file.write(data)
          end
          photo = Photo.new(species: species_model)
          photo.image_path = Pathname.new(file_path).open
          photo.original_url = full_image_path
          photo.save!

        rescue => error
          puts "Failed on " + sci_name + " page: " + page.to_s
          puts "  error: "+error.to_s
          next
        end


      end
      response = HTTParty.get('https://www.herpmapper.org/records?taxon=Serpentes&deceased=no&p=' + page.to_s)
      page += 1
    end
  end
end
