class CreateMedications < ActiveRecord::Migration[7.1]
  def change
    create_table :medications do |t|
      t.string  :name, null: false        # 薬名
      t.string  :dosage, null: false      # 用量（例: "1錠", "5ml"）
      t.integer :timing, null: false      # enum timing (morning/noon/...)
      t.integer :purpose, default: 0      # enum purpose (unspecified/antipyretic/...)

      t.text    :note                     # 任意のメモ

      t.timestamps
    end
  end
end
