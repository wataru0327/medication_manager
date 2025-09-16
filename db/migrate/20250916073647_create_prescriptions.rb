class CreatePrescriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :prescriptions do |t|
      t.references :patient, null: false, foreign_key: { to_table: :users }
      t.references :doctor, null: false, foreign_key: { to_table: :users }
      t.datetime :issued_at, null: false
      t.datetime :expires_at, null: false
      t.string :qr_token, null: false

      t.timestamps
    end

    add_index :prescriptions, :qr_token, unique: true
  end
end

