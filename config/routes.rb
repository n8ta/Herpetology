Rails.application.routes.draw do

  resources :superfamilies
  devise_for :users

  resources :photos
  resources :user_species_data
  resources :regions

  resource :superfamilies
  resources :families
  resources :genera
  resources :species

  root 'home#index'

end
