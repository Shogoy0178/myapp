class AddForeignKeysToPosts < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :posts, :users
    add_foreign_key :posts, :movies
    add_foreign_key :posts, :musics
  end
end
