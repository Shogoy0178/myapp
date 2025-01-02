class AddIndexToMusicsSpotifyTrackId < ActiveRecord::Migration[7.0]
  def change
    add_index :musics, :spotify_track_id, unique: true
  end
end
