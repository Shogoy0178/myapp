# frozen_string_literal: true

# このマイグレーションは、musicsテーブルを追加します。
class CreateMusics < ActiveRecord::Migration[7.0]
  def change
    create_table :musics do |t|
      t.string :spotify_track_id
      t.string :title
      t.string :artist

      t.timestamps
    end
  end
end
