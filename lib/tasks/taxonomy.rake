require 'json'

namespace :imports do
  desc "Download herpmapper taxonomy"
  task taxonomy: :environment do

    puts "Import herpmapper taxonomy from lib/tasks/assets/taxons.json"
    Taxon.destroy_all

    file = File.open(Rails.root.join('lib', 'tasks', 'assets', 'taxons.json'), 'r')
    json = JSON.parse file.read()
    x = 1


    roots = []
    families = []
    genera = []
    species = []

    # key: 'name'
    # val: [common_name, parent_name, rank]
    json.each do |key, val|
      common_name = val[0]
      parent = val[1]
      rank = val[2]
      if rank == "root"
        roots << [key, common_name, parent]
      elsif rank == "family"
        families << [key, common_name, parent]
      elsif rank == "genus"
        genera << [key, common_name, parent]
      elsif rank == "species"
        species << [key, common_name, parent]
      end
    end


    # [name, common_name, parent]
    puts "starting root herps"
    roots.each do | root |
      root_m = Taxon.new(name: root[0], rank: "root", taxon: Taxon.find_by(name: root[2]))
      root_m.save
      begin
      cn_m = CommonName.new(taxon: root_m, name: root[1])
      cn_m.save!
      rescue => error
        puts "bad common name "
      end
    end

    puts "starting families"
    families.each do | fam |
      fam_m = Taxon.new(name: fam[0], rank: "family", taxon: Taxon.find_by(name: fam[2].titleize))
      fam_m.save
      begin
        cn_m = CommonName.new(taxon: fam_m, name: fam[1])
        cn_m.save
      rescue => error
        puts "bad common name "
        puts fam.inspect
        puts "  error: " + error.to_s
        puts "  trace: "+ error.backtrace.to_s
      end
    end

    puts "starting genuses"
    genera.each do | genus |
      genus_m = Taxon.new(name: genus[0], rank: "genus", taxon: Taxon.find_by(name: genus[2].titleize))
      genus_m.save
      begin
        cn_m = CommonName.new(taxon: genus_m, name: genus[1])
        cn_m.save
      rescue => error
        puts "bad common name "
        puts genus.inspect
        puts "  error: " + error.to_s
        puts "  trace: "+ error.backtrace.to_s

      end
    end

    puts "starting species"
    species.each do | specie |
      specie_m = Taxon.new(name: specie[0], rank: "species", taxon: Taxon.find_by(name: specie[2].titleize))
      specie_m.save
      begin
        cn_m = CommonName.new(taxon: specie_m, name: specie[1])
        cn_m.save
      rescue => error
        puts "bad common name "
        puts species.inspect
        puts "  error: " + error.to_s
        puts "  trace: "+ error.backtrace.to_s

      end
    end

    puts "Done importing taxonomy from herpmapper (local cache)"


  end
end
