class User < ApplicationRecord
  authenticates_with_sorcery!

  # ActiveStorage設定
  has_one_attached :avatar

  # バリデーション
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: false) : ActionController::Base.helpers.asset_path("top.jpg")
  end
end
