# frozen_string_literal: true

# ユーザーモデル
class User < ApplicationRecord
  authenticates_with_sorcery!

  # ActiveStorage設定
  has_one_attached :avatar

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  # バリデーション
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
