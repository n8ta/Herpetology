Rails.application.routes.draw do

  resources :superfamilies
  devise_for :users

  resources :photos
  resources :user_species_data
  resources :regions

  resources :families do
    resources :genera do
      resources :species
    end
  end

  root 'home#index'

end
