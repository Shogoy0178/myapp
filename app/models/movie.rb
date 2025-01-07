# app/models/movie.rb
class Movie < ApplicationRecord
  has_many :posts
  
  def self.ransackable_attributes(auth_object = nil)
    %w[id title poster_url trailer_url created_at updated_at]
  end  
end
