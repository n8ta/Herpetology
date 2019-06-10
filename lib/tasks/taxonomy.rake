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
    subfamilies = []
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
      elsif rank == "subfamily"
        subfamilies << [key, common_name, parent]
      end
    end


    # [name, common_name, parent]
    puts "starting root herps"
    roots.each do | root |
      root_m = Taxon.new(name: root[0].titleize, rank: "root", taxon: Taxon.find_by(name: root[2]))
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
      root = Taxon.find_by(name: fam[2].titleize)
      fam_m = Taxon.new(name: fam[0].titleize, rank: "family", taxon: root, root_taxon_id: root.id)
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

    puts "starting sub families"

    subfamilies.each do | sub_fam |
      family = Taxon.find_by(name: sub_fam[2])
      root_m = family
      while not root_m.taxon.nil?
        root_m = root_m.taxon
      end
      fam_m = Taxon.new(name: sub_fam[0], rank: "subfamily", taxon: family, root_taxon_id: root_m.id)
      fam_m.save
      begin
        cn_m = CommonName.new(taxon: fam_m, name: sub_fam[1])
        cn_m.save
      rescue => error
        puts "bad common name "
        puts sub_fam.inspect
        puts "  error: " + error.to_s
        puts "  trace: "+ error.backtrace.to_s
      end
    end

    puts "starting genuses"
    genera.each do | genus |
      family_m = Taxon.find_by(name: genus[2].titleize)
      root_m = family_m
      while not root_m.taxon.nil?
        root_m = root_m.taxon
      end

      genus_m = Taxon.new(name: genus[0], rank: "genus", taxon: family_m, root_taxon_id: root_m.id)
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
      genus = Taxon.find_by(name: specie[2].titleize)

      root_m = genus
      while not root_m.taxon.nil?
        root_m = root_m.taxon
      end

      specie_m = Taxon.new(name: specie[0], rank: "species", taxon: genus, root_taxon_id: root_m.id)
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
