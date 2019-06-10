namespace :imports do

  desc "Import photos from herpmapper"
  task herpmapper: :environment do

    base_urls = ['https://www.herpmapper.org/records?taxon=Gymnophiona&deceased=no&p=', 'https://www.herpmapper.org/records?taxon=Crocodylia&deceased=no&p=', 'https://www.herpmapper.org/records?taxon=Anura&deceased=no&p=', 'https://www.herpmapper.org/records?taxon=Lacertilia&deceased=no&p=', 'https://www.herpmapper.org/records?taxon=Caudata&deceased=no&p=', 'https://www.herpmapper.org/records?taxon=Serpentes&deceased=no&p=', 'https://www.herpmapper.org/records?taxon=Sphenodon&deceased=no&p=', 'https://www.herpmapper.org/records?taxon=Testudines&deceased=no&p=',]
    base_urls.each do |base_url|
      page = 0
      response = HTTParty.get(base_url + page.to_s)
      while (response.code == 200) and (page < 4)
        html = Nokogiri::HTML(response.body)
        table = html.xpath(".//div[@id='content']").xpath('.//table').xpath(".//tr").each do |row|
          puts " --- new --- "
          begin


            # Get tier info for geography
            geography = row.xpath(".//td[@class='hidden-xs']").text # Get the <td> with the geograpgy info
            geography = geography.split("\t").join(" ").split("\n")
            tier1 = geography[1].split(" ").join(" ")
            tier2 = geography[2].split(" ").join(" ")
            tier3 = geography[3].split(" ").join(" ")

            tier1_m = Tier1.find_by(name: tier1)
            tier2_m = nil
            tier3_m = nil
            begin
              tier2_m = Tier2.find_by(name: tier2, tier1: tier1_m)
              tier3_m = Tier3.find_by(name: tier3, tier2: tier2_m)
            rescue
            end
            puts "tier1: " + tier1_m.inspect
            puts "tier2: " + tier2_m.inspect
            puts "tier3: " + tier3_m.inspect

            # Find species taxon model

            links = row.xpath('.//a')
            sci_name = links[2].text.split(" ").join(" ").split("\n").join(" ")

            puts sci_name
            species_model = Taxon.all.species.find_by(name: sci_name.titleize)

            # Add to all regions that we could identify, rescue in case it's already marked for that region
            begin
              unless tier3_m.nil?
                tier3_m.taxons << species_model
              end
              unless tier2_m.nil?
                tier2_m.taxons << species_model
              end
              tier1_m.taxons << species_model

            rescue
            end


            voucher_number = row.xpath(".//td[@width='78']").xpath(".//img/@src").text.split("voucher/")[1].split("/")[0]
            full_image_path = "https://www.herpmapper.org/voucher/" + voucher_number + "/full.jpg"

            image_response = HTTParty.get(full_image_path)
            next unless image_response.code == 200
            data = image_response.body

            file_path = Rails.root.join('tmp/herpmapper/' + SecureRandom.hex(50) + ".jpg")

            File.open(file_path, "w") do |file|
              file.binmode
              file.write(data)
            end
            photo = Photo.new(taxon: species_model)
            photo.image_path = Pathname.new(file_path).open
            photo.original_url = full_image_path
            photo.save!

            File.delete(file_path) if File.exist?(file_path)

          rescue => error
            puts "Failed on " + sci_name + " page: " + page.to_s
            puts "  error: " + error.to_s
            puts "  trace: " + error.backtrace.to_s
            next
          end

        end
        page += 1
        response = HTTParty.get(base_url + page.to_s)
      end
    end
  end
end
