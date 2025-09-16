class CreatePrescriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :prescriptions do |t|
      t.integer :patient_id
      t.integer :doctor_id
      t.datetime :issued_at
      t.datetime :expires_at
      t.string :qr_token

      t.timestamps
    end
  end
end
