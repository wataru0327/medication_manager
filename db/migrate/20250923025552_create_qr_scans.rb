class CreateQrScans < ActiveRecord::Migration[7.1]
  def change
    create_table :qr_scans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :prescription, null: false, foreign_key: true  # ← 追加！
      t.string :token

      t.timestamps
    end
  end
end

