Rails.application.routes.draw do
  resources :targets do
    resources :results, only: %i[create index show]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#top'
end
