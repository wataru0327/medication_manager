class AddPatientNumberToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :patient_number, :integer
    add_index :users, :patient_number, unique: true
  end
end
