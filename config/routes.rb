Rails.application.routes.draw do



  devise_for :users, :controllers => {:registrations => 'users/registrations'}


  devise_scope :user do
    post '/users/email_available/:email' => 'users/registrations#email_available'
    post '/users/username_available/:username' => 'users/registrations#username_available'
    post '/users/show_dead' => 'users/sessions#show_dead', as: 'show_dead'
    post '/users/hide_dead' => 'users/sessions#hide_dead', as: 'hide_dead'
    get '/users/show_dead' => 'users/sessions#show_dead'
    get '/users/hide_dead' => 'users/sessions#hide_dead'
  end

  get '/photos/:photo_id/report' => 'reports#new', as: 'new_photo_report'

  resources :user_taxon_data, only: [:show]

  root :to => 'redirect#redir'

  namespace 'quiz' do
    root :to => 'quiz#pick_taxon'
    get '/' => 'quiz#pick_taxon', as: 'pick_taxon'
    get '/pick_taxon' => 'quiz#pick_taxon_all', as: 'pick_taxon_all'
    get 'taxon/:taxon_id' => 'quiz#pick_region', as: 'pick_region'
    get 'taxon/:taxon_id/region/:region_id' => 'quiz#game', as: 'game'
    post 'taxon/:taxon_id/region/:region_id' => 'quiz#guess', as: 'guess'
    get 'scoreboard' => 'quiz#scoreboard', as: 'scoreboard'
  end

  resources :reports do
    collection do
      post 'approve' => 'reports#approve', as: 'approve'
    end
  end
  resources :photos, only: [:edit, :show, :update, :destroy]

  resources :taxons do
    collection do
      get 'search/:name' => 'taxons#search', as: 'search'
    end
    resources :regions, only: [:show] do
    end
  end

end

