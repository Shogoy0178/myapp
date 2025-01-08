# frozen_string_literal: true

# このマイグレーションは、usersテーブルにavatar_urlカラムを追加します。
class AddAvatarUrlToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :avatar_url, :string
  end
end
