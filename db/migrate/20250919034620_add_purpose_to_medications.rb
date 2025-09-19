class AddPurposeToMedications < ActiveRecord::Migration[7.1]
  def change
    add_column :medications, :purpose, :integer, null: false, default: 0
  end
end
