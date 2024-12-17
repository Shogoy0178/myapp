class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :tmdb_movie_id
      t.string :title
      t.string :poster_url
      t.string :trailer_url

      t.timestamps
    end
  end
end
