Rails.application.routes.draw do
  # トップページ
  root "home#top"

  # ユーザー管理
  resources :users, only: %i[new create index show]

  # セッション管理（ログイン・ログアウト）
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # 投稿管理 + いいね機能
  resources :posts, only: %i[index new create edit update destroy show] do
    resources :likes, only: %i[create destroy]  # 複数の「いいね」を管理
  end

  resources :movies, only: [:index, :show] do
    collection do
      post :save_selected
    end
  end  
  resources :musics, only: [:index, :show] do
    collection do
      post :save_selected
    end
  end  
end
