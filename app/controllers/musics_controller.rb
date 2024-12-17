class MusicsController < ApplicationController
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'])

  def index
    if params[:query].present?
      @musics = RSpotify::Track.search(params[:query], limit: 20)
    else
      @musics = fetch_random_musics
    end
  end

  def show
    # Spotifyの楽曲情報をIDで取得
    @music = RSpotify::Track.find(params[:id])
  rescue StandardError => e
    Rails.logger.error "Spotify API Error: #{e.message}"
    redirect_to musics_path, alert: "楽曲情報が取得できませんでした。"
  end

  private

  def fetch_random_musics
    random_query = ('a'..'z').to_a.concat((0..9).to_a.map(&:to_s)).sample
    tracks = RSpotify::Track.search(random_query, limit: 50)
    tracks.sample(10)
  rescue StandardError => e
    Rails.logger.error "Spotify API Error: #{e.message}"
    []
  end
end
