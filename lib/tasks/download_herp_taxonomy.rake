require 'json'

namespace :imports do
  desc "Download herpmapper taxonomy"
  task download_herp_taxonomy: :environment do
    data = {} # name: [common_name,parent_name]
    Taxon.destroy_all
    base_url = "https://www.herpmapper.org/taxon/"
    queue = Queue.new
    queue << 'amphisbaenia'
    queue << 'gymnophiona'
    queue << 'crocodylia'
    queue << 'anura'
    queue << 'lacertilia'
    queue << 'caudata'
    queue << 'serpentes'
    queue << 'sphenodon'
    queue << 'testudines'
    data['amphisbaenia'] = ['Worm Lizards', nil, 'root']
    data['gymnophiona'] = ['Limbless Amphibians', nil, 'root']
    data['crocodylia'] = ['Alligators, Crocodiles, and Caimans', nil, 'root']
    data['anura'] = ['Frogs and Toads', nil, 'root']
    data['lacertilia'] = ['Lizards', nil, 'root']
    data['caudata'] = ['Salamanders', nil, 'root']
    data['serpentes'] = ['Snakes', nil, 'root']
    data['sphenodon'] = ['Tuataras', nil, 'root']
    data['testudines'] = ['Turtles and Tortoises', nil, 'root']

    x = 0

    while (queue.size() != 0)
      x += 1
      puts x
      name = queue.pop()
        response = HTTParty.get(base_url + name.split(" ").join("_"))
        html = Nokogiri::HTML(response.body)
        taxons = html.xpath(".//table")[3]

        begin
          taxons = taxons.xpath(".//tr")
        rescue
          # empty taxon all done
          next
        end
        taxons.each do |row|
          tds = row.xpath(".//td")
          taxon_name = tds[0].text.split(" ").join(" ")
          taxon_cn = tds[1].text.split(" ").join(" ")
          taxon_rank = tds[2].text.split(" ").join(" ")
          data[taxon_name] = [taxon_cn, name, taxon_rank]
          unless taxon_rank == "species"
              queue << taxon_name
          end
        end

    end

    File.open(Rails.root.join('lib', 'tasks', 'assets', 'taxons.json'), "w") do |fle|
      fle.write(data.to_json)
    end

  end
end
