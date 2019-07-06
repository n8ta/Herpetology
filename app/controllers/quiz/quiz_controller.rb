module Quiz
  class QuizController < ApplicationController
    before_action :set_taxon, only: [:pick_region, :game, :guess]
    before_action :set_region, only: [:game, :guess]

    def pick_region
      if @taxon.taxon != nil
        flash[:alert] = "Can only use root taxons like Snakes or Frogs and Lizards"
        redirect_to '/'
      end
      @regions = @taxon.valid_regions.countries
    end

    def scoreboard
      @users_total_correct = User.all.sort {|a, b| b.total_correct <=> a.total_correct}
      @users_sci_acc = User.all.sort {|a, b| b.accuracy_scientific <=> a.accuracy_scientific}
      @users_com_acc = User.all.sort {|a, b| b.accuracy_common <=> a.accuracy_common}

      @correct_ids = @users_total_correct.each_with_index.map {|user, i| {'rank': i+1, 'username': user.username, 'score': user.total_correct}}
      @sci_acc = @users_total_correct.each_with_index.map {|user, i| {'rank': i+1, 'username': user.username, 'score': user.accuracy_scientific}}
      @com_acc = @users_total_correct.each_with_index.map {|user, i| {'rank': i+1, 'username': user.username, 'score': user.accuracy_common}}

      respond_to do |format|
        format.html { }
        format.json { render :json => ranks }
      end
    end

    def guess
      body = JSON.parse request.body.read
      species = @region.taxons.species.where(root_taxon_id: @taxon.id, photographed: true)
      puts "species:"
      puts species.inspect
      specie_m = Taxon.all.species.find(session[:specie_id])
      sci_correct = session[:sci_index].to_s == body['sci_guess']
      common_correct = session[:common_index].to_s == body['common_guess']
      old_sci_index = session[:sci_index]
      old_common_index = session[:common_index]
      old_photo_id = session[:photo_id]
      hash_specie_photo = specie_hash(species)

      photo = hash_specie_photo[2]

      specie_data = {
          'sci_name': specie_m.name.to_s,
          'common_name': specie_m.common_names.any? ? specie_m.common_names[0].name.to_s : nil,
          'species_id': specie_m.id,
          'venomous': specie_m.venomous,
          'next_options': hash_specie_photo[0],
          'next_image_path': photo.image_path.url,
          'correct_sci_index': old_sci_index,
          'correct_common_index': old_common_index,
          'sci_correct': sci_correct,
          'common_correct': common_correct,
          'photo_id': old_photo_id
      }
      datum = UserTaxonDatum.find_or_create_by(user: current_user, taxon: specie_m)
      if current_user
        if sci_correct
          datum.sci_guess_correct
        else
          datum.sci_guess_incorrect
        end
        if common_correct
          datum.common_guess_correct
        else
          datum.common_guess_incorrect
        end
      end
      render :json => specie_data
    end


    def game
      @regions = @region.regions
      @species = @region.taxons.species.where(root_taxon_id: @taxon.id, photographed: true)
      options = specie_hash(@species)
      correct_specie = options[1]
      @photo = correct_specie.photos[rand(correct_specie.photos.size)]
      @options = options[0]
    end

    def pick_taxon_all
      @taxons = Taxon.roots.includes(:common_names)
      render 'pick_taxon'
    end

    def pick_taxon
      @taxons = [Taxon.find(7), Taxon.find(5), Taxon.find(9), Taxon.find(6)]
    end

    private


    def specie_hash(species)
      if species.length < 6
        raise "Not enough species"
      end
      len = species.length
      correct_specie = species[rand(len)]
      picked = [correct_specie]
      hash_data = {'sci' => [], 'common' => []}
      i = 0
      while (picked.length < 5) and (i < 100)
        i += 1
        trial_specie = species[rand(len)]
        unless picked.include?(trial_specie)

          if current_user
            data = UserTaxonDatum.find_or_create_by(user: current_user, taxon: trial_specie)

            if data.seen != 0
              if (rand(1000).to_f / 1000) < [data.correct / data.seen, 0.85].min
                next
              end
              # skip with probability 1-ratio, with ratio capped at .85
            end


          end

          picked.push(trial_specie)
          hash_data['sci'].push(trial_specie.sci_name)
          hash_data['common'].push(trial_specie.common_names[0].name)
        end
      end


      photos = correct_specie.photos
      puts "Photo I"
      puts photos.inspect
      unless current_user && current_user.show_dead_photos == true
        photos = photos.where(dead: false)
      end
      puts "Photos:"
      puts photos.inspect
      photo = photos[rand(photos.size - 1)]
      puts "Photo:"
      puts photo.inspect

      sci_index = rand(4)
      common_index = rand(4)
      hash_data['sci'].insert(sci_index, correct_specie.name)
      hash_data['common'].insert(common_index, correct_specie.common_names[0].name)
      session[:sci_index] = sci_index
      session[:common_index] = common_index
      session[:specie_id] = correct_specie.id
      session[:photo_id] = photo.id
      return [hash_data, correct_specie, photo] # hash, Species model
    end

    def set_taxon
      @taxon = Taxon.find params[:taxon_id]
    end

    def set_region
      @region = Region.find params[:region_id]
    end
  end
end