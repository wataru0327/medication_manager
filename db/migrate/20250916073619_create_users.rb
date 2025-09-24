class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## 独自カラム
      t.string :name, null: false
      t.integer :role, null: false # enum (doctor, pharmacy, patient)

      ## Devise が必要とするカラム
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable (必要ならコメントアウト解除)
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end

