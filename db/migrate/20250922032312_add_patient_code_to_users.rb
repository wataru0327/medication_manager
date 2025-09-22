class AddPatientCodeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :patient_code, :string
    add_index  :users, :patient_code, unique: true
  end
end

