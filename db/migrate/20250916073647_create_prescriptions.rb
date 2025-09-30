class CreatePrescriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :prescriptions do |t|
      t.references :doctor, null: false, foreign_key: { to_table: :users } # 医師
      t.references :patient, foreign_key: { to_table: :users }            # 患者（optional: true なので null 許可）

      t.string :patient_name, null: false, limit: 50   # 患者名
      t.string :hospital_name                          # 病院名
      t.string :patient_code                           # 患者コード
      t.string :patient_number                         # 患者番号

      t.date :issued_at, null: false                   # 発行日
      t.date :expires_at, null: false                  # 有効期限
      t.string :qr_token, null: false                  # QRコード用トークン

      t.timestamps
    end

    # ユニーク制約
    add_index :prescriptions, :qr_token, unique: true
  end
end
