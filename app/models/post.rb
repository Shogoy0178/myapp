class Post < ApplicationRecord
  belongs_to :user
  belongs_to :movie, optional: true
  belongs_to :music, optional: true

  validates :body, presence: true
end
