Rails.application.routes.draw do

  resources :superfamilies
  devise_for :users

  resources :photos
  resources :common_names
  resources :user_species_data
  resources :regions do
    member do
      post 'guess/:guess_index' =>'regions#guess'
    end
  end
  resource :superfamilies
  resources :families
  resources :genera
  resources :species
  root 'regions#index'
end
