class CreateMedicationIntakes < ActiveRecord::Migration[7.1]
  def change
    create_table :medication_intakes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :prescription_item, null: false, foreign_key: true
      t.datetime :taken_at, null: false
      t.timestamps
    end
  end
end

