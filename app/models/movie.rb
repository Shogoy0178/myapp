# frozen_string_literal: true

# 映画モデル
class Movie < ApplicationRecord
  has_many :posts

  def self.ransackable_attributes(_auth_object = nil)
    %w[id title poster_url trailer_url created_at updated_at]
  end
end
