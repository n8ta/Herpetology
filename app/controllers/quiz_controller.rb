class QuizController < ApplicationController
  before_action :set_tier, only: [:show, :guess]

  def set_tier
    @tier = nil
    if params.keys.include?("tier1_id")
      @tier = Tier1.find params['tier1_id']
    elsif params.keys.include?("tier2_id")
      @tier = Tier2.find params['tier2_id']
    elsif params.keys.include?("tier3_id")
      @tier = Tier3.find params['tier3_id']
    end
  end

  def index

    @tier1s = Tier1.all
    @tier1s = @tier1s.select {|t1| t1.name != "United States of America" }

  end

  def guess
    species = @tier.species.includes(:photos).where.not(photos: {id: nil})
    specie_m = Species.find(session[:specie_id])
    correct = session[:index].to_s == params['guess_index'].to_s
    old_index = session[:index]
    hash_and_specie = specie_hash(species)
    photo = hash_and_specie[1].photos[rand(hash_and_specie[1].photos.length)]
    specie_data = {
        'sci_name': specie_m.sci_name.to_s,
        'common_name': specie_m.common_names.any? ? specie_m.common_names[0].name.to_s : nil,
        'species_id': specie_m.id,
        'next_options': hash_and_specie[0],
        'next_image_path': photo.image_path.url,
        'correct': correct,
        'correct_index': old_index,
        'guess_index': params['guess_index'],
    }
    if (current_user)
      datum = UserSpeciesDatum.find_or_create_by(user: current_user, species: specie_m)
      correct ? datum.guess_correct : datum.guess_incorrect # Increment counter for species
    end
    render :json => specie_data
  end

  def show
    puts "hit show"
    @species = @tier.species.includes(:photos).where.not(photos: {id: nil})
    puts "start hasing"
    options = specie_hash(@species)
    puts "done hashing"
    correct_specie = options[1]
    puts "correct"
    @photo = correct_specie.photos[rand(correct_specie.photos.length)]
    puts "correct photo found"
    @options = options[0]
    puts "rendering"
  end

  def specie_hash(species)
    puts "reached func"
    if species.length < 6
      raise "Not enough species"
      puts "not enough species"
    end
    puts 'enough species'
    len = species.length
    correct_specie = species[rand(len)]
    puts 'picked correct'
    picked = [correct_specie]
    puts 'array'
    hash_data = []
    puts 'hash array'
    i = 0
    while (picked.length < 7) and (i<100)
      i += 1
      puts "loop i: "+i.to_s
      trial_specie = species[rand(len)]
      puts "trial spec"
      unless picked.include?(trial_specie)
        puts "trial is a new species adding"
        picked.push(trial_specie)
        puts "pushed to array"
        hash_data.push({sci_name: trial_specie.sci_name,
                        common_name: trial_specie.common_names.any? ? trial_specie.common_names[0].name : ' '})
        puts "added to hash"
      end
    end
    puts "done looping"
    index = rand(4)
    puts "pick index"
    hash_data.insert(index, {sci_name: correct_specie.sci_name,
                             common_name: correct_specie.common_names.any? ? correct_specie.common_names[0].name : ' '})
    puts "insert correct specie"
    session[:index] = index
    session[:specie_id] = correct_specie.id
    puts "set session and return"
    return [hash_data, correct_specie] # hash, Species model
  end

end
