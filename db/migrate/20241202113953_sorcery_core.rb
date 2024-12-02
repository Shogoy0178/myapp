class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :crypted_password, null: false
      t.string :salt  # Sorceryはデフォルトでsaltを使用する
      t.string :reset_password_token
      t.datetime :reset_password_token_expired_at
      t.datetime :reset_password_email_sent_at

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
