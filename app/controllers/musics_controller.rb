class MusicsController < ApplicationController
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'])

  # 一覧表示
  def index
    if params[:query].present?
      @musics = search_musics(params[:query])
    else
      @musics = fetch_random_musics
    end

    # ページネーション設定
    @musics = Kaminari.paginate_array(@musics).page(params[:page]).per(9)
  end

  def save_selected
    selected_music_id = params[:selected_music_id]
    post_id = params[:post_id] # 投稿IDを取得
  
    if selected_music_id.present?
      begin
        @music = RSpotify::Track.find(selected_music_id)
        
        # セッションにデータを保存
        session[:selected_music] = {
          id: @music.id,
          name: @music.name,
          artist: @music.artists.map(&:name).join(', '),
          album: @music.album.name,
          external_url: @music.external_urls['spotify']
        }
  
        # 投稿IDが渡されていれば、その投稿を更新する
        if post_id.present?
          post = Post.find(post_id)
  
          # 音楽が存在しない場合、Musics テーブルに新しい音楽情報を追加
          music = Music.find_or_create_by(spotify_track_id: @music.id) do |m|
            m.spotify_track_id = @music.id
            m.title = @music.name
            m.artist = @music.artists.map(&:name).join(', ')
          end
  
          # 音楽IDを投稿に関連付け
          post.music_id = music.id
          post.save
        end
  
        # 投稿IDが渡されていればedit画面、なければnew画面へ遷移
        if post_id.present?
          redirect_to edit_post_path(post_id)
        else
          redirect_to new_post_path
        end
  
      rescue StandardError => e
        Rails.logger.error "Spotify API Error during save_selected: #{e.message}"
        redirect_to musics_path, alert: "選択した楽曲を保存できませんでした。"
      end
    else
      redirect_to musics_path, alert: "音楽を選択してください。"
    end
  end  


  private

  def search_musics(query)
    begin
      RSpotify::Track.search(query, limit: 20)
    rescue StandardError => e
      Rails.logger.error "Spotify API Error during search: #{e.message}"
      redirect_to musics_path, alert: "楽曲を検索できませんでした。" and return []
    end
  end

  def fetch_random_musics
    random_query = generate_random_query
    begin
      tracks = RSpotify::Track.search(random_query, limit: 50)
      tracks.sample(10)
    rescue StandardError => e
      Rails.logger.error "Spotify API Error during random fetch: #{e.message}"
      []
    end
  end

  def generate_random_query
    charset = [('a'..'z'), (0..9)].map(&:to_a).flatten
    Array.new(2) { charset.sample }.join
  end
end
