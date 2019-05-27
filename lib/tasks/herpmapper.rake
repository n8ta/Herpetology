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

    page = 10
    response = HTTParty.get('https://www.herpmapper.org/records?taxon=Serpentes&deceased=no&p='+page.to_s)
    while response.code == 200

      html_doc = Nokogiri::HTML(response.body)


      response = HTTParty.get('https://www.herpmapper.org/records?taxon=Serpentes&deceased=no&p='+page.to_s)
      page += 1
    end







    file_path = Rails.root.join('tmp/reddit/' + species + genus + File.extname(comment.link_url))

    File.open(file_path, "w") do |file|
      file.binmode
      file.write(data)
    end


    photo = Photo.new(species: species_model)
    photo.image_path = Pathname.new(file_path).open
    photo.original_url = comment.link_url
    photo.save!


  end
end
