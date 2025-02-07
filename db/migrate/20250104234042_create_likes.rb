# frozen_string_literal: true

# いいねテーブルの作成
class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end

    # ユニークインデックスの追加（同じユーザーが同じ投稿に複数回「いいね」できないようにする）
    add_index :likes, %i[user_id post_id], unique: true
  end
end
