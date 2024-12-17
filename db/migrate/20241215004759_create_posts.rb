class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :body, null: false
      t.bigint :user_id, null: false
      t.bigint :movie_id
      t.bigint :music_id

      t.timestamps
    end

    add_foreign_key :posts, :users
    add_foreign_key :posts, :movies
    add_foreign_key :posts, :musics
    add_index :posts, :user_id
    add_index :posts, :movie_id
    add_index :posts, :music_id
  end
end
