Rails.application.routes.draw do

  # resources :tips
  devise_for :users, :controllers => { :registrations => 'users/registrations' }

  resources :user_taxon_data, only: [:show]
  root 'quiz#pick_taxon'

  get '/quiz/scoreboard.json' => 'quiz#scoreboard', as: 'scoreboard'

  get '/quiz' => 'quiz#pick_taxon', as: 'pick_taxon'
  get '/quiz/taxon/:taxon_id' => 'quiz#pick_region', as: 'pick_region'
  get '/quiz/taxon/:taxon_id/region/:region_id' => 'quiz#game', as: 'game'
  post '/quiz/taxon/:taxon_id/region/:region_id/guess/:guess_index' => 'quiz#guess', as: 'guess'

  resources :taxons do
    resources :regions, only: [:show] do
    end
  end

end

