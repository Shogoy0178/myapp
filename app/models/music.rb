class Music < ApplicationRecord
  has_many :posts

  def self.ransackable_attributes(auth_object = nil)
    %w[id title artist spotify_track_id created_at updated_at]
  end
end
