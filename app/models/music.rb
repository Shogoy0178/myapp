# app/models/music.rb
class Music < ApplicationRecord
  has_many :posts
end