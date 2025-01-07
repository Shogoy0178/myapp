class Post < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  belongs_to :music
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user  

  validates :body, presence: true, unless: -> { movie.present? || music.present? }
  validate :at_least_one_association_present

  def at_least_one_association_present
    if body.blank? && movie.nil? && music.nil?
      errors.add(:base, "コメント、映画、または音楽のいずれかを入力してください。")
    end
  end

end
