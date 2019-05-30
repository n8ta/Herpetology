Rails.application.routes.draw do

  devise_for :users

  resources :photos
  resources :regions do
    member do
      post 'guess/:guess_index' =>'regions#guess'
    end
  end
  root 'regions#index'
end
