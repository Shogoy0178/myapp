class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :set_movie, only: [:new, :create]
  before_action :set_music, only: [:new, :create]

  # 一覧表示
  # posts_controller.rb
  def index
    @posts = Post.includes(:movie, :music).all
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

  def create
    # current_user を使用して新しい Post を初期化
    @post = current_user.posts.new(post_params)
    logger.debug "Initialized post: #{@post.attributes}"
  
    # 映画情報をセッションから取得して movie テーブルに保存
    if session[:selected_movie].present?
      movie_data = session[:selected_movie]
      logger.debug "Session movie data: #{movie_data}"
  
      # 新しい映画を保存
      movie = Movie.create(
        tmdb_movie_id: movie_data["id"],
        title: movie_data["title"],
        poster_url: movie_data["poster_url"],
        trailer_url: movie_data["trailer_url"]
      )
      logger.debug "Created movie: #{movie.attributes}" if movie.persisted?
      logger.debug "Movie save errors: #{movie.errors.full_messages}" unless movie.persisted?
  
      # 保存した映画を Post に関連付け
      @post.movie = movie
    else
      logger.debug "No movie data in session."
    end
  
    # 音楽情報をセッションから取得して music テーブルに保存
    if session[:selected_music].present?
      music_data = session[:selected_music]
      logger.debug "Session music data: #{music_data}"
  
      # 新しい音楽を保存
      music = Music.create(
        spotify_track_id: music_data["id"],
        title: music_data["name"],
        artist: music_data["artist"]
      )
      logger.debug "Created music: #{music.attributes}" if music.persisted?
      logger.debug "Music save errors: #{music.errors.full_messages}" unless music.persisted?
  
      # 保存した音楽を Post に関連付け
      @post.music = music
    else
      logger.debug "No music data in session."
    end
  
    # Post を保存
    if @post.save
      logger.debug "Post saved successfully: #{@post.attributes}"
      # 成功時にセッション情報を削除
      session.delete(:selected_movie)
      session.delete(:selected_music)
      redirect_to posts_path, notice: "投稿が作成されました。"
    else
      # 保存失敗時のデバッグログとエラーメッセージ
      logger.debug "Post save failed: #{@post.errors.full_messages}"
      flash.now[:alert] = "投稿の作成に失敗しました。入力内容を確認してください。"
      render :new
    end
  end
  

  # 編集フォーム
  def edit
  end

  # 投稿の更新
  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: "投稿が更新されました。"
    else
      render :edit
    end
  end

  # 投稿の削除
  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿が削除されました。"
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
