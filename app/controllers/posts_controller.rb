# frozen_string_literal: true

# 投稿コントローラ
class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_post, only: %i[edit update destroy]
  before_action :set_movie, only: %i[new create]
  before_action :set_music, only: %i[new create]

  # 一覧表示
  def index
    clear_session
    @q = Post.ransack(params[:q])
    @posts = @q.result.includes(:user, :movie, :music).page(params[:page]).per(4)
  end

  # 新規作成フォーム
  def new
    @selected_movie = session[:selected_movie]
    @selected_music = session[:selected_music]
    @post = Post.new
  end

  # 戻るボタンのアクション
  def cancel
    clear_session
    redirect_to posts_path
  end

  # 投稿作成
  def create
    @post = current_user.posts.new(post_params)
    assign_movie_to_post
    assign_music_to_post

    if @post.save
      clear_session
      redirect_to posts_path, notice: '投稿が作成されました。'
    else
      handle_create_failure
    end
  end

  # 投稿詳細表示
  def show
    @post = Post.includes(:movie, :music).find(params[:id])
  end

  # 編集フォーム
  def edit
    @post = Post.includes(:movie, :music).find(params[:id])
  end

  # 投稿更新
  def update
    if @post.update(post_params)
      update_movie
      update_music
      redirect_to posts_path, notice: '投稿が更新されました。'
    else
      handle_update_failure
    end
  end

  # 投稿削除
  def destroy
    @post.destroy
    redirect_to posts_path, notice: '投稿が削除されました。'
  end

  # 自分の投稿
  def my_posts
    @q = current_user.posts.ransack(params[:q])
    @posts = @q.result.page(params[:page]).per(4)
    render :index
  end

  # いいねした投稿
  def liked_posts
    @q = current_user.liked_posts.ransack(params[:q])
    @posts = @q.result.includes(:user, :movie, :music).page(params[:page]).per(4)
    render :index
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body, :movie_id, :music_id)
  end

  def set_movie
    @movie = session[:selected_movie]
  end

  def set_music
    @music = session[:selected_music]
  end

  def clear_session
    session.delete(:selected_movie)
    session.delete(:selected_music)
  end

  def assign_movie_to_post
    return unless session[:selected_movie].present?

    movie_data = session[:selected_movie]
    movie = Movie.find_or_create_by(tmdb_movie_id: movie_data['id']) do |m|
      m.tmdb_movie_id = movie_data['id']
      m.title = movie_data['title']
      m.poster_url = movie_data['poster_url']
      m.trailer_url = movie_data['trailer_url']
    end
    @post.movie = movie
  end

  def assign_music_to_post
    return unless session[:selected_music].present?

    music_data = session[:selected_music]
    music = Music.find_or_create_by(spotify_track_id: music_data['id']) do |m|
      m.spotify_track_id = music_data['id']
      m.title = music_data['name']
      m.artist = music_data['artist']
    end
    @post.music = music
  end

  def update_movie
    return unless session[:selected_movie].present?

    movie_data = session[:selected_movie]
    movie = @post.movie || Movie.find_by(tmdb_movie_id: movie_data['id'])
    movie ||= Movie.create(
      tmdb_movie_id: movie_data['id'],
      title: movie_data['title'],
      poster_url: movie_data['poster_url'],
      trailer_url: movie_data['trailer_url']
    )
    @post.movie = movie
  end

  def update_music
    return unless session[:selected_music].present?

    music_data = session[:selected_music]
    music = @post.music || Music.find_by(spotify_track_id: music_data['id'])
    music ||= Music.create(
      spotify_track_id: music_data['id'],
      title: music_data['name'],
      artist: music_data['artist']
    )
    @post.music = music
  end

  def handle_create_failure
    @selected_movie = session[:selected_movie] if session[:selected_movie].present?
    @selected_music = session[:selected_music] if session[:selected_music].present?
    flash.now[:alert] = '投稿の作成に失敗しました。入力内容を確認してください。'
    render :new
  end

  def handle_update_failure
    flash.now[:alert] = '投稿の更新に失敗しました。入力内容を確認してください。'
    render :edit
  end
end
