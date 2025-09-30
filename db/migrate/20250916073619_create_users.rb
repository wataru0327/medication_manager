class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      # Devise
      t.string  :email,              null: false, default: ""
      t.string  :encrypted_password, null: false, default: ""

      # 共通
      t.string  :name, null: false
      t.integer :role, null: false, default: 2  # enum 用: 0=doctor,1=pharmacy,2=patient

      # 医師・薬局用
      t.string  :hospital_name

      # 患者用
      t.string  :patient_code        # QRコード用
      t.integer :patient_number      # 自動採番される患者番号

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :patient_number, unique: true
  end
end

