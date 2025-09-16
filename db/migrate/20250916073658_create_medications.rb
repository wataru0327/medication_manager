class CreateMedications < ActiveRecord::Migration[7.1]
  def change
    create_table :medications do |t|
      t.references :prescription, null: false, foreign_key: true
      t.string :name, null: false
      t.string :dosage, null: false
      t.integer :timing, null: false # enum (morning, noon, evening, bedtime)

      t.timestamps
    end
  end
end

