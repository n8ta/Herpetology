Rails.application.routes.draw do

  devise_for :users
  resources :user_species_data, only: [:show]
  resources :regions do
    member do
      post 'guess/:guess_index' =>'regions#guess'
    end
  end
  root 'regions#index'
end