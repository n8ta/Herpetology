namespace :imports do

  desc "Tag taxons by region from herpmapper predownloaded data"
  task herp_regions: :environment do

    file = File.open(Rails.root.join('lib', 'tasks', 'assets', 'herp_regions.json'), 'r')
    json = JSON.parse file.read()


    puts json.length
    x = 0

    name_to_id = {}
    def lookup (region_name,name_to_id)
      return nil if region_name == ""
      id = name_to_id[region_name]
      if id.nil?
        puts name_to_id.keys.length
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


    json.each do |herp|
      puts "---- HERP ----" + x.to_s
      x += 1
      puts "num regions: "+herp[1].length.to_s

      s = Time.now.to_i
      taxon = Taxon.find_by(name: herp[0])
      puts "lookup taxon: " + (Time.now.to_i - s).to_s
      herp[1].each do |regions|
        s = Time.now.to_i

        country = lookup regions[0], name_to_id
        state = lookup regions[1], name_to_id
        county = lookup regions[2], name_to_id
        # puts "lookup regions: " + (Time.now.to_i - s).to_s
        begin
          s = Time.now.to_i
          taxon.regions << country
          taxon.regions << state
          taxon.regions << county
          puts "add regions: " + (Time.now.to_i - s).to_s
        rescue
        end
      end
    end


  end
end
