class QuizController < ApplicationController
  before_action :set_tier, only: [:show, :guess]
  before_action :set_taxon, only: [:guess, :show, :taxon]

  def scoreboard
    if current_user
      ranks = [{'rank': 1, 'name': 'Nate', 'score': 142},
               {'rank': 2, 'name': 'Avita', 'score': 134},
               {'rank': 3, 'name': 'Kurt', 'score': 120}
      ]
      render :json => ranks
    else
      render :json, 'You must sign in'
    end
  end

  def taxon
    @tier1s = Tier1.all.select { |t1| t1.taxons.species.select { |sp| sp.num_photos > 0 and sp.root == @taxon  }.count > 6 }

  end


  def index
    @taxons = Taxon.all.roots
  end

  def guess
    species = @tier.taxons.species.select{ |sp| sp.num_photos > 0 and sp.root == @taxon }
    specie_m = Taxon.all.species.find(session[:specie_id])
    correct = session[:index].to_s == params['guess_index'].to_s
    old_index = session[:index]
    hash_and_specie = specie_hash(species)
    photo = hash_and_specie[1].photos[rand(hash_and_specie[1].photos.length)]
    specie_data = {
        'sci_name': specie_m.name.to_s,
        'common_name': specie_m.common_names.any? ? specie_m.common_names[0].name.to_s : nil,
        'species_id': specie_m.id,
        'next_options': hash_and_specie[0],
        'next_image_path': photo.image_path.url,
        'correct': correct,
        'correct_index': old_index,
        'guess_index': params['guess_index'],
    }
    if (current_user)
      datum = UserTaxonDatum.find_or_create_by(user: current_user, taxon: specie_m)
      correct ? datum.guess_correct : datum.guess_incorrect # Increment counter for species
    end
    render :json => specie_data
  end

  def show

    @species = @tier.taxons.species.select{ |sp| sp.num_photos > 0 and sp.root == @taxon }
    options = specie_hash(@species)
    correct_specie = options[1]
    @photo = correct_specie.photos[rand(correct_specie.photos.length)]
    @options = options[0]

  end

  def specie_hash(species)
    if species.length < 6
      raise "Not enough species"
    end
    len = species.length
    correct_specie = species[rand(len)]
    picked = [correct_specie]
    hash_data = []
    i = 0
    while (picked.length < 7) and (i < 100)
      i += 1
      trial_specie = species[rand(len)]
      unless picked.include?(trial_specie)
        picked.push(trial_specie)
        hash_data.push({sci_name: trial_specie.name,
                        common_name: trial_specie.common_names.any? ? trial_specie.common_names[0].name : ' '})
      end
    end
    index = rand(4)
    hash_data.insert(index, {sci_name: correct_specie.name,
                             common_name: correct_specie.common_names.any? ? correct_specie.common_names[0].name : ' '})
    session[:index] = index
    session[:specie_id] = correct_specie.id
    return [hash_data, correct_specie] # hash, Species model
  end

  private
  def set_taxon
    @taxon = Taxon.find params['taxon_id']
  end

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
end
