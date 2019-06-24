require 'json'

namespace :imports do
  desc "Import geographic regions from predownloaded json file"
  task herp_create_regions: :environment do

    file = File.open(Rails.root.join('lib', 'tasks', 'assets', 'geo.json'), 'r')
    json = JSON.parse file.read()

    t1_id_to_model = {}
    t2_id_to_model = {}
    t3_id_to_model = {}

    puts "len: "+json.length.to_s

    json.each do |id, geo|
      if geo['parent'] == '0'
        t1_model = Region.new(name: geo['name'])
        t1_model.save!
        t1_id_to_model[id] = t1_model
      end
    end

    puts "Finished Countries"

    x=0
    json.each do |id, geo|
      x+=1
      puts id.inspect
      puts geo.inspect
      puts "t2: "+x.to_s
      if t1_id_to_model.key?(geo['parent'])
        puts "pre model"
        parent = t1_id_to_model[geo['parent']]
        t2_model = Region.new(name: geo['name'], region: parent)
        if parent == nil
          raise
        end
        puts "created model"
        t2_model.save!
        puts "saved"
        t2_id_to_model[id] = t2_model
        puts "added"
      end
    end

    puts "Finished sub-country regions"

    x=0
    json.each do |id, geo|
      x+=1
      puts "t3: "+x.to_s
      if t2_id_to_model.key?(geo['parent'])
        parent = t2_id_to_model[geo['parent']]
        if parent == nil
          raise
        end
        t3_model = Region.new(name: geo['name'],
                             region: parent)
        puts "new moddel"
        t3_model.save!
        puts "saved"
        t3_id_to_model[id] = t3_model
        puts "added"

      end
    end

    puts "Finished sub-sub-country regions"

    puts "Created " + t1_id_to_model.length.to_s + ' t1s'
    puts "Created " + t2_id_to_model.length.to_s + ' t2s'
    puts "Created " + t3_id_to_model.length.to_s + ' t3s'


  end
end