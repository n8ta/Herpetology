Rails.application.routes.draw do

  devise_for :users
  resources :user_species_data, only: [:show]
  resources :regions do
    member do
      post 'guess/:guess_index' =>'regions#guess'
    end
  end

  root 'quiz#index'
  get 'quiz/scoreboard.json' => 'quiz#scoreboard', as: 'scoreboard'
  get 'quiz/tier1/:tier1_id' => 'quiz#show', as: 't1quiz'
  get 'quiz/tier2/:tier2_id' => 'quiz#show', as: 't2quiz'
  get 'quiz/tier3/:tier3_id' => 'quiz#show', as: 't3quiz'
  post 'quiz/tier1/:tier1_id/guess/:guess_index' => 'quiz#guess', as: 't1quiz_guess'
  post 'quiz/tier2/:tier2_id/guess/:guess_index' => 'quiz#guess', as: 't2quiz_guess'
  post 'quiz/tier3/:tier3_id/guess/:guess_index' => 'quiz#guess', as: 't3quiz_guess'



  resources :tier1s
  resources :tier2s

  resources :species, only: [:show, :index]
  resources :genera, only: [:show, :index]
  resources :families, only: [:show, :index]
  resources :superfamilies, only: [:show, :index]
end

