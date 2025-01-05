class Post < ApplicationRecord
  belongs_to :user
  belongs_to :movie, optional: true
  belongs_to :music, optional: true
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user  

  validates :body, presence: true
end
