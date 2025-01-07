Rails.application.routes.draw do
  # トップページ
  root "home#top"

  # ユーザー管理
  resources :users, only: %i[new create index show]

  # セッション管理（ログイン・ログアウト）
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  resources :posts, only: %i[index new create edit update destroy show] do
    collection do
      get :my_posts     # マイ投稿ビュー
      get :liked_posts  # いいね投稿一覧ビュー
      post :cancel      # 戻るボタン用のアクション（POSTメソッドに変更）
    end  
    resources :likes, only: %i[create destroy]  # いいねの管理
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
