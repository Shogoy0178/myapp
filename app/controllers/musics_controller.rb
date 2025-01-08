# frozen_string_literal: true

class MusicsController < ApplicationController
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_SECRET_ID'])

  def index
    @musics = if params[:query].present?
                search_musics(params[:query])
              else
                fetch_random_musics
              end

    @musics = Kaminari.paginate_array(@musics).page(params[:page]).per(9)
  end

  def save_selected
    selected_music_id = params[:selected_music_id]
    post_id = params[:post_id]

    if selected_music_id.present?
      begin
        @music = find_music(selected_music_id)
        save_music_to_session(@music)

        if post_id.present?
          handle_post_update(post_id, @music)
        else
          redirect_to new_post_path
        end
      end
    else
      redirect_to musics_path, alert: '音楽を選択してください。'
    end
  end

  private

  def search_musics(query)
    RSpotify::Track.search(query, limit: 20)
  end

  def fetch_random_musics
    random_query = generate_random_query
    begin
      tracks = RSpotify::Track.search(random_query, limit: 50)
      tracks.sample(10)
    end
  end

  def generate_random_query
    charset = [('a'..'z'), (0..9)].map(&:to_a).flatten
    Array.new(2) { charset.sample }.join
  end

  # 楽曲情報をSpotifyから取得
  def find_music(selected_music_id)
    RSpotify::Track.find(selected_music_id)
  end

  # セッションに楽曲情報を保存
  def save_music_to_session(music)
    session[:selected_music] = {
      id: music.id,
      name: music.name,
      artist: music.artists.map(&:name).join(', '),
      album: music.album.name,
      external_url: music.external_urls['spotify']
    }
  end

  # 投稿情報を更新
  def handle_post_update(post_id, music)
    post = Post.find(post_id)

    music_record = Music.find_or_create_by(spotify_track_id: music.id) do |m|
      m.spotify_track_id = music.id
      m.title = music.name
      m.artist = music.artists.map(&:name).join(', ')
    end

    post.music_id = music_record.id
    post.save

    redirect_to edit_post_path(post_id)
  end
end
