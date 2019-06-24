namespace :imports do

  desc "Tag taxons by region from herpmapper predownloaded data"
  task herp_regions: :environment do

    file = File.open(Rails.root.join('lib', 'tasks', 'assets', 'old_herp_regions.json'), 'r')
    json = JSON.parse file.read()

    puts json.length
    x=0
    json.each do |herp|
      x+=1
      puts "x: "+x.to_s
      taxon = Taxon.find_by(name: herp[0])
      herp[1].each do |regions|

        country = Region.find_by(name: regions[0])
        state = Region.find_by(name: regions[1])
        county = Region.find_by(name: regions[2])
        begin
        taxon.regions << country
        taxon.regions << state
        taxon.regions << county
        rescue
        end
      end
    end


  end
end
