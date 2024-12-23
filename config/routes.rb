Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "home#top"
  resources :users, only: %i[new create index show]
  # セッション管理（ログイン・ログアウト）
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resources :posts, only: [:index, :show]
  resources :movies, only: [:index, :show]
  resources :musics, only: [:index, :show]
end
