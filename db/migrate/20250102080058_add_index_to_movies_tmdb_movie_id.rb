class AddIndexToMoviesTmdbMovieId < ActiveRecord::Migration[7.0]
  def change
    add_index :movies, :tmdb_movie_id, unique: true
  end
end
