class CreatePrescriptionItems < ActiveRecord::Migration[7.1]
  def change
    create_table :prescription_items do |t|
      t.references :prescription, null: false, foreign_key: true
      t.references :medication, null: false, foreign_key: true

      t.string :dosage, null: false         # 服用量（例: 1錠）
      t.string :timing, null: false         # 服用タイミング（例: 朝・昼・夜）
      t.integer :days, null: false          # 服用日数

      t.timestamps
    end
  end
end
