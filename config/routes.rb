Rails.application.routes.draw do

  # resources :tips
  devise_for :users, :controllers => { :registrations => 'users/registrations' }

  resources :user_taxon_data, only: [:show]

  root :to => 'redirect#redir'

  namespace 'quiz' do
    root :to => 'quiz#pick_taxon'
    get '/' => 'quiz#pick_taxon', as: 'pick_taxon'
    get '/pick_taxon' => 'quiz#pick_taxon_all', as: 'pick_taxon_all'
    get 'scoreboard.json' => 'quiz#scoreboard', as: 'scoreboard'
    get 'taxon/:taxon_id' => 'quiz#pick_region', as: 'pick_region'
    get 'taxon/:taxon_id/region/:region_id' => 'quiz#game', as: 'game'
    post 'taxon/:taxon_id/region/:region_id' => 'quiz#guess', as: 'guess'
  end




  resources :taxons do
    resources :regions, only: [:show] do
    end
  end

end

