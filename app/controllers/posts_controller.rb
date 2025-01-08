# frozen_string_literal: true

# 投稿コントローラ
class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_post, only: %i[edit update destroy]
  before_action :set_movie, only: %i[new create]
  before_action :set_music, only: %i[new create]

  # 一覧表示
  # posts_controller.rb
  def index
    # セッション情報を削除
    session.delete(:selected_movie)
    session.delete(:selected_music)

    # Ransack検索オブジェクトを作成
    @q = Post.ransack(params[:q])

    # 検索結果を取得（投稿とユーザ情報、関連モデルを含む）
    @posts = @q.result.includes(:user, :movie, :music).page(params[:page]).per(4)
  end

  # 新規作成フォーム
  def new
    @selected_movie = session[:selected_movie]  # セッションから映画情報を取得
    @selected_music = session[:selected_music]  # セッションから音楽情報を取得
    logger.debug "@selected_music の内容: #{@selected_music.inspect}"
    @post = Post.new

    # セッション情報がある場合、投稿後に削除するために保持する
    # @selected_movieがnilの場合、フォーム内で何も表示しない
  end

  # 戻るボタンのアクション
  def cancel
    session.delete(:selected_movie)  # セッションから映画情報を削除
    session.delete(:selected_music)  # セッションから音楽情報を削除

    redirect_to posts_path # または他の適切なパス
  end

  def create
    # current_user を使用して新しい Post を初期化
    @post = current_user.posts.new(post_params)
    logger.debug "Initialized post: #{@post.attributes}"

    # 映画情報をセッションから取得して movie テーブルに保存
    if session[:selected_movie].present?
      movie_data = session[:selected_movie]
      logger.debug "Session movie data: #{movie_data}"

      # 映画が既に存在するか確認（重複防止）
      movie = Movie.find_or_create_by(tmdb_movie_id: movie_data['id']) do |m|
        m.tmdb_movie_id = movie_data['id']
        m.title = movie_data['title']
        m.poster_url = movie_data['poster_url']
        m.trailer_url = movie_data['trailer_url']
      end
      logger.debug "Created movie: #{movie.attributes}" if movie.persisted?
      logger.debug "Movie save errors: #{movie.errors.full_messages}" unless movie.persisted?

      # 保存した映画を Post に関連付け
      @post.movie = movie
    else
      logger.debug 'No movie data in session.'
    end

    # 音楽情報をセッションから取得して music テーブルに保存
    if session[:selected_music].present?
      music_data = session[:selected_music]
      logger.debug "Session music data: #{music_data}"

      # 音楽が既に存在するか確認（重複防止）
      music = Music.find_or_create_by(spotify_track_id: music_data['id']) do |m|
        m.spotify_track_id = music_data['id']
        m.title = music_data['name']
        m.artist = music_data['artist']
      end
      logger.debug "Created music: #{music.attributes}" if music.persisted?
      logger.debug "Music save errors: #{music.errors.full_messages}" unless music.persisted?

      # 保存した音楽を Post に関連付け
      @post.music = music
    else
      logger.debug 'No music data in session.'
    end

    # Post を保存
    if @post.save
      logger.debug "Post saved successfully: #{@post.attributes}"
      # 成功時にセッション情報を削除
      session.delete(:selected_movie)
      session.delete(:selected_music)
      redirect_to posts_path, notice: '投稿が作成されました。'
    else
      # 保存失敗時の処理
      @selected_movie = session[:selected_movie] if session[:selected_movie].present?
      @selected_music = session[:selected_music] if session[:selected_music].present?

      # 保存失敗時のデバッグログとエラーメッセージ
      logger.debug "Post save failed: #{@post.errors.full_messages}"
      flash.now[:alert] = '投稿の作成に失敗しました。入力内容を確認してください。'
      render :new
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

  def update
    # 映画と音楽を更新する
    if @post.update(post_params)
      if session[:selected_movie].present?
        movie_data = session[:selected_movie]

        # 映画が存在するか確認
        movie = @post.movie || Movie.find_by(tmdb_movie_id: movie_data['id'])

        if movie.nil?
          # 映画が見つからない場合、新しく作成
          movie = Movie.create(
            tmdb_movie_id: movie_data['id'],
            title: movie_data['title'],
            poster_url: movie_data['poster_url'],
            trailer_url: movie_data['trailer_url']
          )
        end

        # 更新した映画を再関連付け
        @post.movie = movie
      end

      if session[:selected_music].present?
        music_data = session[:selected_music]

        # 音楽が存在するか確認
        music = @post.music || Music.find_by(spotify_track_id: music_data['id'])

        if music.nil?
          # 音楽が見つからない場合、新しく作成
          music = Music.create(
            spotify_track_id: music_data['id'],
            title: music_data['name'],
            artist: music_data['artist']
          )
        end

        # 更新した音楽を再関連付け
        @post.music = music
      end

      # 投稿を保存してリダイレクト
      redirect_to posts_path, notice: '投稿が更新されました。'
    else
      # 更新失敗時の処理
      flash.now[:alert] = '投稿の更新に失敗しました。入力内容を確認してください。'
      render :edit
    end
  end

  # 投稿の削除
  def destroy
    @post.destroy
    redirect_to posts_path, notice: '投稿が削除されました。'
  end

  def my_posts
    @q = current_user.posts.ransack(params[:q]) # Ransackオブジェクトを作成
    @posts = @q.result.page(params[:page]).per(4) # 検索結果をページネーション
    render :index
  end

  def liked_posts
    @q = current_user.liked_posts.ransack(params[:q]) # Ransackオブジェクトを作成
    @posts = @q.result.includes(:user, :movie, :music).page(params[:page]).per(4) # 検索結果をページネーション
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
    @movie = session[:selected_movie]  # セッションから映画情報を取得
  end

  def set_music
    @music = session[:selected_music]  # 音楽情報（もし必要であれば）
  end
end
