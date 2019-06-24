class QuizController < ApplicationController
  before_action :set_taxon, only: [:pick_region, :game, :guess]
  before_action :set_region, only: [:game, :guess]

  def pick_region
  end

  def scoreboard
    if current_user
      user_ranks = User.all.sort { |a, b| b.score <=> a.score }


      ranks = [{'rank': 1, 'name': user_ranks[0].username, 'score':  user_ranks[0].score},
               {'rank': 2, 'name':  user_ranks[1].username, 'score':  user_ranks[1].score},
               {'rank': 3, 'name':  user_ranks[2].username, 'score':  user_ranks[2].score}
      ]
      render :json => ranks
    else
      render :json, 'You must sign in'
    end
  end

  def guess
    species = @region.taxons.species.select{ |sp| sp.num_photos > 0 and sp.root == @taxon }
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


  def game
    @regions = @region.regions
    @species = @region.taxons.species.select{ |sp| sp.num_photos > 0 and sp.root == @taxon }
    options = specie_hash(@species)
    correct_specie = options[1]
    @photo = correct_specie.photos[rand(correct_specie.photos.length)]
    @options = options[0]
  end

  def pick_taxon
    @taxons = Taxon.roots
  end

  private


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

        if current_user
          data = UserTaxonDatum.find_or_create_by(user: current_user, taxon: trial_specie)

          if data.seen != 0
            if (rand(1000).to_f/1000) < [data.correct/data.seen,0.85].min
              next
            end
            # skip with probability 1-ratio, with ratio capped at .85
          end


        end

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

  def set_taxon
    @taxon = Taxon.find params[:taxon_id]
  end

  def set_region
    @region = Region.find params[:region_id]
  end
end
