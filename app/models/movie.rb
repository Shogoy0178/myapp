class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :tmdb_movie_id, null: false
      t.string :title, null: false
      t.string :poster_url
      t.string :trailer_url

      t.timestamps
    end

    add_index :movies, :tmdb_movie_id, unique: true
  end
end
