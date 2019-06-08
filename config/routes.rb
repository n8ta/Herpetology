Rails.application.routes.draw do

  resources :tier3s, only: [:show]
  resources :tier2s, only: [:show]
  resources :tier1s, only: [:show, :index]

  devise_for :users
  resources :user_species_data, only: [:show]
  resources :regions do
    member do
      post 'guess/:guess_index' =>'regions#guess'
    end
  end
  root 'regions#index'

  resources :species, only: [:show, :index]
  resources :genera, only: [:show, :index]
  resources :families, only: [:show, :index]
  resources :superfamilies, only: [:show, :index]
end

