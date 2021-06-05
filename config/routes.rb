Rails.application.routes.draw do


  devise_for :users, :controllers => {registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks'}
  devise_scope :user do
    post '/users/email_available/:email' => 'users/registrations#email_available'
    post '/users/username_available/:username' => 'users/registrations#username_available'
    post '/users/settings' => 'users/sessions#settings', as: 'settings'
    get '/users/set_username' => 'social#set_username', as: "set_username"
    post '/users/set_username' => 'social#post_set_username', as: "post_set_username"
    post '/users/set_return_url' => 'social#set_return_url', as: "set_return_url"
  end

  get '/photos/:photo_id/report' => 'reports#new', as: 'new_photo_report'

  post '/google_token' => 'social#google_token', as: "google_token"

  resources :user_taxon_data, only: [:show]

  root :to => 'taxons#index'

  resources :groups, only: [:index, :show] do
    member do
      get 'next' => 'groups#next'
      post 'next' => 'groups#post_next'
    end
  end

  resources :reports do
    member do
      post 'approve/:report_type' => 'reports#approve', as: 'approve'
      post 'reject/:report_type' => 'reports#reject', as: 'reject'
    end
  end

  resources :photos, only: [:edit, :show, :update, :destroy, :show]

  get '/scoreboard' => 'game#scoreboard', as: 'scoreboard'


  resources :taxons, only: [:show, :index] do
    collection do
      get 'all' => 'taxons#index_all', as: 'all'
      get 'search/:name' => 'taxons#search', as: 'search'
      get 'search' => 'taxons#search'
    end
    member do
      get 'photos/rand' => 'taxons#photos_rand', as: 'rand'
      get 'photos/plenty' => 'taxons#photos_plenty', as: 'plenty'
    end
      resources :regions, only: [:show, :index] do
      member do
        get ':mode' => 'game#game', as: 'game'
        post ':mode' => 'game#guess', as: 'guess'
      end
    end
  end

end

