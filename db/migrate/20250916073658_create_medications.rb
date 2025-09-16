class CreateMedications < ActiveRecord::Migration[7.1]
  def change
    create_table :medications do |t|
      t.integer :prescription_id
      t.string :name
      t.string :dosage
      t.integer :timing

      t.timestamps
    end
  end
end
