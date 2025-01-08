# frozen_string_literal: true

# 投稿モデル
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  belongs_to :music
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :body, presence: true
  validate :at_least_one_association_present

  def at_least_one_association_present
    return unless body.blank? && movie.nil? && music.nil?

    errors.add(:base, 'コメント、映画、または音楽のいずれかを入力してください。')
  end

  # 検索可能な属性を明示的に許可
  def self.ransackable_attributes(_auth_object = nil)
    %w[body created_at id movie_id music_id updated_at user_id]
  end

  # 検索可能な関連を明示的に許可
  def self.ransackable_associations(_auth_object = nil)
    %w[movie music user]
  end
end
