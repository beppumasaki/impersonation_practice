Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#top'
  get '/terms', to: 'static_pages#terms'
  get '/privacy', to: 'static_pages#privacy'
  get '/info', to: 'static_pages#info'
  get '/sitemap', to: redirect("https://s3-ap-northeast-1.amazonaws.com/impersonation-book/sitemaps/sitemap.xml.gz")
  get 'search_tag', to: 'targets#search_tag'

  resources :users, only: %i[new create show edit update]

  resources :targets do
    resources :results, only: %i[create]
  end

  resources :results, only: %i[index show edit update destroy] do
    resources :collaborations, only: %i[new create]
    resources :comments, only: %i[create destroy]
  end

  resources :collaborations, only: %i[destroy update show edit index] do
    resources :collaboration_comments, only: %i[create destroy]
  end
  
  resources :votes, only: %i[new create destroy index] do
    resource :likes, only: %i[create destroy]
  end

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'ranks', to: 'ranks#index'
  get 'boards', to: 'boards#index'
  get 'collaboration_boards', to: 'collaboration_boards#index'

  namespace :admin do
    root to: 'dashboards#index'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'
    resources :users, only: %i[index edit update show destroy]
    resources :targets, only: %i[create new index edit update show destroy]
    resources :tags, only: %i[create new index edit update destroy]
  end

end
