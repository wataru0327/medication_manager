class AddPatientNameToPrescriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :prescriptions, :patient_name, :string
  end
end
