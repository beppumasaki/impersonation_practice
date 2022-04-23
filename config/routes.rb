Rails.application.routes.draw do
  
  resources :targets do
    resources :results, only: %i[create index show]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#top'

  resources :users, only: %i[new create show edit update] do
    resources :collaborations, only: %i[index]
    resources :results, only: %i[index show edit update destroy] do
      resources :collaborations, only: %i[create destroy new show]
      resources :comments, only: %i[create destroy]
    end
  end


  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'ranks', to: 'ranks#index'


  namespace :admin do
    root to: 'dashboards#index'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'
    resources :users, only: %i[index edit update show destroy]
    resources :targets, only: %i[create new index edit update show destroy]
  end

end
