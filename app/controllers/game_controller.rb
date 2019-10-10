class GameController < ApplicationController
  before_action :set_taxon, only: [:pick_region, :game, :guess]
  before_action :set_region, only: [:game, :guess]
  before_action :set_mode, only: [:game, :guess]

  def scoreboard
    limit = 10
    # TBH this code should be swapped out with a hash user: rank then we can check the hash for the current_user and add it if needed
    # but right now we just check for the whole hash which is sketch af.
    # I'll fix this at some point...... He said never going to touch the code again.
    @users_total_correct = User.all.sort {|a, b| b.total_correct <=> a.total_correct}[0..limit - 1].each_with_index.map {|user, i| {'rank': i + 1, 'username': user.username, 'score': user.total_correct}}
    @users_sci_acc = User.all.sort {|a, b| b.accuracy_scientific <=> a.accuracy_scientific}[0..limit - 1].each_with_index.map {|user, i| {'rank': i + 1, 'username': user.username, 'score': user.accuracy_scientific}}
    @users_com_acc = User.all.sort {|a, b| b.accuracy_common <=> a.accuracy_common}[0..limit - 1].each_with_index.map {|user, i| {'rank': i + 1, 'username': user.username, 'score': user.accuracy_common}}
    @users_reports = User.all.sort {|a, b| b.approved_reports.size <=> a.approved_reports.size}[0..limit - 1].each_with_index.map {|user, i| {'rank': i + 1, 'username': user.username, 'score': user.approved_reports.size}}
    if current_user
      # Add current user to end of scoreboard b/c that's what everyone really cares about
      cu_total_hash = {'rank': current_user.place_on_scoreboard, 'username': current_user.username, 'score': current_user.total_correct}
      # current_user, hash of their rank, username, and score for display on the scoreboard
      unless @users_total_correct.include?(cu_total_hash)
        @users_total_correct << cu_total_hash
      end
      cu_sci_hash = {'rank': current_user.place_on_sci_scoreboard, 'username': current_user.username, 'score': current_user.accuracy_scientific}
      # current user hash of scientific scoreboard rank
      unless @users_sci_acc.include?(cu_sci_hash)
        @users_sci_acc << cu_sci_hash
      end
      cu_com_hash = {'rank': current_user.place_on_common_scoreboard, 'username': current_user.username, 'score': current_user.accuracy_common}
      # current_user hash of common name scoreboard rank
      unless @users_com_acc.include?(cu_com_hash)
        @users_com_acc << cu_com_hash
      end
      cu_report_hash = {'rank': current_user.place_report_scoreboard, 'username': current_user.username, 'score': current_user.approved_reports.size}
      # current_user hash of report score
      unless @users_reports.include?(cu_report_hash)
        @users_reports << cu_report_hash
      end
    end
  end

  def guess
    if params[:mode] == "quiz"

      body = JSON.parse request.body.read
      species = @region.taxons.species.where(root_taxon_id: @taxon.id, photographed: true)
      specie_m = Taxon.all.species.find(session[:specie_id])
      sci_correct = session[:sci_index].to_s == body['sci_guess']
      common_correct = session[:common_index].to_s == body['common_guess']
      old_sci_index = session[:sci_index]
      old_common_index = session[:common_index]
      old_photo_id = session[:photo_id]
      hash_specie_photo = specie_hash(species)

      photo = hash_specie_photo[2]

      venomous = "unknown"
      venomous == "venomous" if venomous == true
      venomous == "nonvenomous" if venomous == false

      specie_data = {
          'sci_name': specie_m.sci_name.to_s,
          'common_name': specie_m.common_names.any? ? specie_m.common_names[0].name.to_s : nil,
          'species_id': specie_m.id,
          'venomous': venomous,
          'next_options': hash_specie_photo[0],
          'next_image_path': photo.image_path.url,
          'correct_sci_index': old_sci_index,
          'correct_common_index': old_common_index,
          'sci_correct': sci_correct,
          'common_correct': common_correct,
          'next_photo_id': photo.id
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
      return render :json => specie_data
    elsif params[:mode] == "learn"
    end
  end

  def learn_guess

  end

  def game
    if @mode == "quiz"
      @regions = @region.regions
      @species = @region.taxons.species.where(root_taxon_id: @taxon.id, photographed: true)
      options = specie_hash(@species)
      correct_specie = options[1]
      @photo = correct_specie.photos[rand(correct_specie.photos.size)]
      @options = options[0]
    elsif @mode == "learn"
      @regions = @region.regions
      @taxons = @region.taxons.species.where(root_taxon_id: @taxon.id, photographed: true)
      @taxons = @taxons.map {|tx| tx.attributes}
      @taxons.each do |sp|
        if (sp["venomous"] == true)
          sp[:venomous] = "venomous"
        elsif (sp["venomous"] == false)
          sp[:venomous] = "nonvenomous"
        else
          sp[:venomous] = "unknown"
        end
      end
      @species = @taxons
    end
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


    photos = correct_specie.photos.where(hidden: false)
    unless current_user && current_user.show_dead_photos == true
      photos = photos.where(dead: false)
    end
    photo = photos[rand(photos.size - 1)]

    sci_index = rand(4)
    common_index = rand(4)
    hash_data['sci'].insert(sci_index, correct_specie.sci_name)
    hash_data['common'].insert(common_index, correct_specie.common_name)
    session[:sci_index] = sci_index
    session[:common_index] = common_index
    session[:specie_id] = correct_specie.id
    session[:photo_id] = photo.id
    return [hash_data, correct_specie, photo] # hash, Species model
  end

  def set_taxon
    @taxon = Taxon.find params[:taxon_id]
  end

  def set_mode
    @mode = params[:mode]
    raise if (@mode != "quiz") && (@mode != "learn")
  end

  def set_region
    @region = Region.find params[:id]
  end
end