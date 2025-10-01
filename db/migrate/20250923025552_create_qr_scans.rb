class CreateQrScans < ActiveRecord::Migration[7.1]
  def change
    create_table :qr_scans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :prescription, null: false, foreign_key: true
      t.string :token, null: false

      t.timestamps
    end
  end
end
