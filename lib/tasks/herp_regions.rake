namespace :imports do

  desc "Tag taxons by region from herpmapper predownloaded data"
  task herp_regions: :environment do

    file = File.open(Rails.root.join('lib', 'tasks', 'assets', 'herp_regions.json'), 'r')
    json = JSON.parse file.read()

    nil_regions = Set.new
    nil_taxons = Set.new

    rescued_country = 0
    rescued_state = 0
    rescued_county = 0
    name_to_id = {}

    def lookup (region_name, name_to_id)
      return nil if region_name == ""
      region_name = region_name.split(' ').join(' ')
      id = name_to_id[region_name]
      if id.nil?
        reg = Region.where('lower(name) = ?', region_name.downcase).first
        if reg.nil?
          puts region_name
          return nil
        end
        name_to_id[region_name] = reg.id
        return reg
      else
        return Region.find id
      end
    end

    puts json.length
    x = 0
    json.each do |herp, regions|
      x += 1
      puts x
      name = herp
      split = name.split(" ")
      if split.length == 3
        name = split[0] + ' ' + split[1]
      end
      taxon = Taxon.find_by(name: name)
      if taxon.nil?
        next
      end

      regions.each do |region|

        country = lookup region[0], name_to_id
        # nil_regions.add(region[0]) if country.nil?
        state = lookup region[1], name_to_id
        # nil_regions.add(region[1]) if state.nil?
        county = lookup region[2], name_to_id
        # nil_regions.add(region[2]) if county.nil?
        begin
          taxon.regions << country
        rescue => e
          # puts e.backtrace.join("\n")
          rescued_country += 1
        end
        begin
          taxon.regions << state
        rescue => e
          # puts e.backtrace.join("\n")
          rescued_state += 1
        end
        begin
          taxon.regions << county
        rescue => e
          # puts e.backtrace.join("\n")
          rescued_county += 1
        end
      end
      # puts "Nil regions: " + nil_regions.count.to_s
      # puts "Nil taxons:" + nil_taxons.count.to_s
      puts 'rescued_country: '+rescued_country.to_s
      puts 'rescued_state: '+rescued_state.to_s
      puts 'rescued_county: '+rescued_county.to_s



    end
    puts nil_regions.inspect
    puts nil_taxons.inspect


  end
end
