require 'json'

namespace :imports do
  desc "Import geographic regions from predownloaded json file"
  task geography: :environment do

    Tier3.destroy_all
    Tier2.destroy_all
    Tier1.destroy_all

    file = File.open(Rails.root.join('lib', 'tasks', 'assets', 'geo.json'), 'r')
    json = JSON.parse file.read()

    t1_id_to_model = {}
    t2_id_to_model = {}
    t3_id_to_model = {}

    json.each do |id, geo|
      if geo['parent'] == '0'
        t1_model = Tier1.new(name: geo['name'])
        t1_model.save
        t1_id_to_model[id] = t1_model
      end
    end

    json.each do |id, geo|
      if t1_id_to_model.key?(geo['parent'])
        t2_model = Tier2.new(name: geo['name'],
                             tier1: t1_id_to_model[geo['parent']])
        t2_model.save
        t2_id_to_model[id] = t2_model
      end
    end

    json.each do |id,geo|
      if t2_id_to_model.key?(geo['parent'])
        t3_model = Tier3.new(name: geo['name'],
                             tier2: t2_id_to_model[geo['parent']])
        t3_model.save
        t3_id_to_model[id] = t3_model

      end
    end

    puts "Created "+t1_id_to_model.length.to_s+' t1s'
    puts "Created "+t2_id_to_model.length.to_s+' t2s'
    puts "Created "+t3_id_to_model.length.to_s+' t3s'


  end
end