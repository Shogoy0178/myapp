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
  end

  def show
    @music = session[:selected_music]
  
    Rails.logger.debug "セッションの音楽情報: #{@music}"
  
    if @music
      @music_id = @music[:id]
      @music_title = @music[:name]
      @music_artist = @music[:artist]
    else
      redirect_to musics_path, alert: "音楽情報が見つかりません。"
    end
  end

  # save_selectedアクション内
  def save_selected
    selected_music_id = params[:selected_music_id]

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
        
        # セッションに保存されたデータをログに表示して確認
        Rails.logger.debug "セッションに保存された音楽情報: #{session[:selected_music]}"

        redirect_to new_post_path
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
