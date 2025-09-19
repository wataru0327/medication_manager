class RemovePrescriptionIdFromMedications < ActiveRecord::Migration[7.1]
  def change
    remove_reference :medications, :prescription, null: false, foreign_key: true
  end
end
