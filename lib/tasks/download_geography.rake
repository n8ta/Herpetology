require 'json'

namespace :imports do
  desc "Import geographic regions"
  task download_geography: :environment do
    base_url = "https://www.herpmapper.org/ajax/boundaries?parent="
    geos = {}
    x=0
    queue = Queue.new
    queue << "0"
    while (queue.size() != 0)
      id = queue.pop
      response = HTTParty.get(base_url + id.to_s)
      json = JSON.parse(response.body)
      json.each do |geo|
        x += 1
        geos[geo['id']] = {'parent': id, 'name': geo['name']}
        if geo['id'].to_i <= 3575
          queue << geo['id']
        else
          puts "skipping: "+geo['id']
        end
        puts geo['name']
        puts x
      end
    end

    File.open(Rails.root.join('lib', 'tasks', 'assets', 'geo.json'), "w") do |fle|
      fle.write(geos.to_json)
    end
  end
end