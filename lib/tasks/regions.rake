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

  desc "Import Regions + common names"
  task regions: :environment do
    # https://www.discoverlife.org/mp/20q?guide=Snakes
    def import_region(file_path, region)
      region_tagged = 0
      text = IO.read(file_path)
      html = Nokogiri::HTML(text)
      html.xpath(".//td[@valign='top']").each do |specie|
        genus_species = specie.xpath(".//a[@target='c2']").text
        common_name = specie.xpath(".//font[@size='-1']").text
        begin
          genus_name = genus_species.split(" ")[0].split(" ").join(" ").split('\n').join(" ")
          species_name = genus_species.split(" ")[1].split(" ").join(" ").split('\n').join(" ")
        rescue
          y = 1
        end
        species_m = nil
        begin
          species_m = find_species(genus_name, species_name)
        rescue
          # puts 'skipped'
          next
        end


        begin
          species_m.regions << region
          region_tagged += 1
        rescue
          puts 'failed'
        end


        if common_name
          begin
            cnm = CommonName.new(name: common_name, species: species_m)
            cnm.save!
          rescue
          end
        end


      end
      puts 'Completed, tagged: ' + region_tagged.to_s


    end

    nae = Region.find_by(name: "North America East")
    naw = Region.find_by(name: "North America West")
    nae_path = Rails.root.join('lib', 'tasks', 'assets', 'nae.html')
    naw_path = Rails.root.join('lib', 'tasks', 'assets', 'naw.html')
    import_region(nae_path,nae)
    import_region(naw_path, naw)


  end
end
