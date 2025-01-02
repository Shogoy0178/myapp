# app/models/movie.rb
class Movie < ApplicationRecord
  has_many :posts
end
