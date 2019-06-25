namespace :imports do

  desc "Tag taxons by region from herpmapper predownloaded data"
  task herp_regions: :environment do

    file = File.open(Rails.root.join('lib', 'tasks', 'assets', 'herp_regions.json'), 'r')
    json = JSON.parse file.read()



    name_to_id = {}
    def lookup (region_name,name_to_id)
      return nil if region_name == ""
      id = name_to_id[region_name]
      if id.nil?
        begin
        reg = Region.find_by!(name: region_name)
        rescue
          return nil
        end
        name_to_id[region_name] = reg.id
        return reg
      else
        return Region.find id
      end
    end
    puts json.length
    x=0
    json.each do |herp|
      x+=1
      puts x

      s = Time.now.to_i
      name =  herp[0]
      split = name.split(" ")
      if split.length == 3
        name = split[0]+' '+split[1]
      end
      taxon = Taxon.find_by(name: name.titleize)

      next if taxon.nil?
      herp[1].each do |regions|
        s = Time.now.to_i

        country = lookup regions[0], name_to_id
        state = lookup regions[1], name_to_id
        county = lookup regions[2], name_to_id
        begin
          s = Time.now.to_i
          taxon.regions << country
          taxon.regions << state
          taxon.regions << county
        rescue
        end
      end
    end


  end
end
