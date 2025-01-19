# frozen_string_literal: true

Rails.application.routes.draw do
  # トップページ
  root 'home#top'

  # ユーザー管理
  resources :users, only: %i[index show new create edit update]

  # セッション管理（ログイン・ログアウト）
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout

  # 投稿管理
  resources :posts, only: %i[index new create edit update destroy show] do
    collection do
      get :my_posts
      get :liked_posts
      post :cancel
    end
    resources :likes, only: %i[create destroy]
  end

  # 映画情報管理
  resources :movies, only: %i[index show] do
    collection do
      post :save_selected
    end
  end

  # 音楽情報管理
  resources :musics, only: %i[index show] do
    collection do
      post :save_selected
    end
  end
end
