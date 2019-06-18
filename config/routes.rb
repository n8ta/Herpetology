Rails.application.routes.draw do

  devise_for :users
  resources :user_taxon_data, only: [:show]
  resources :regions do
    member do
      post 'guess/:guess_index' => 'regions#guess'
    end
  end

  root 'quiz#index'
  get 'quiz/taxon/:taxon_id/' => 'quiz#taxon', as: 'quiz_taxon'
  get 'quiz/scoreboard.json' => 'quiz#scoreboard', as: 'scoreboard'
  get 'quiz/taxon/:taxon_id/tier1/:tier1_id' => 'quiz#show', as: 't1_taxon_quiz'
  get 'quiz/taxon/:taxon_id/tier2/:tier2_id' => 'quiz#show', as: 't2_taxon_quiz'
  get 'quiz/taxon/:taxon_id/tier3/:tier3_id' => 'quiz#show', as: 't3_taxon_quiz'
  post 'quiz/taxon/:taxon_id/tier1/:tier1_id/guess/:guess_index' => 'quiz#guess', as: 't1_taxon_quiz_guess'
  post 'quiz/taxon/:taxon_id/tier2/:tier2_id/guess/:guess_index' => 'quiz#guess', as: 't2_taxon_quiz_guess'
  post 'quiz/taxon/:taxon_id/tier3/:tier3_id/guess/:guess_index' => 'quiz#guess', as: 't3_taxon_quiz_guess'

  resources :taxons do
    resources :tier1s
    resources :tier2s
    resources :tier3s
  end
end

