class CreateMusics < ActiveRecord::Migration[6.1]
  def change
    create_table :musics do |t|
      t.string :spotify_track_id, null: false
      t.string :title, null: false
      t.string :artist, null: false

      t.timestamps
    end

    add_index :musics, :spotify_track_id, unique: true
  end
end
