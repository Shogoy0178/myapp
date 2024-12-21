class MusicsController < ApplicationController
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'])

  def index
    if params[:query].present?
      @musics = search_musics(params[:query])
    else
      @musics = fetch_random_musics
    end
  end

  def show
    @music = fetch_music_by_id(params[:id])
  end

  private

  # 楽曲を検索するメソッド
  def search_musics(query)
    RSpotify::Track.search(query, limit: 20)
  rescue StandardError => e
    Rails.logger.error "Spotify API Error during search: #{e.message}"
    redirect_to musics_path, alert: "楽曲を検索できませんでした。" and return []
  end

  # 特定のIDで楽曲を取得するメソッド
  def fetch_music_by_id(id)
    RSpotify::Track.find(id)
  rescue StandardError => e
    Rails.logger.error "Spotify API Error during fetch by ID: #{e.message}"
    redirect_to musics_path, alert: "楽曲情報が取得できませんでした。" and return nil
  end

  # ランダムな楽曲を取得するメソッド
  def fetch_random_musics
    random_query = generate_random_query
    tracks = RSpotify::Track.search(random_query, limit: 50)
    tracks.sample(10)
  rescue StandardError => e
    Rails.logger.error "Spotify API Error during random fetch: #{e.message}"
    []
  end

  # ランダムなクエリを生成するメソッド
  def generate_random_query
    charset = [('a'..'z'), (0..9)].map(&:to_a).flatten
    Array.new(2) { charset.sample }.join # 2文字のランダムクエリを生成
  end
end
