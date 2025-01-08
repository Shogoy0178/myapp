# frozen_string_literal: true

# 音楽モデル
class Music < ApplicationRecord
  has_many :posts

  def self.ransackable_attributes(_auth_object = nil)
    %w[id title artist spotify_track_id created_at updated_at]
  end
end
