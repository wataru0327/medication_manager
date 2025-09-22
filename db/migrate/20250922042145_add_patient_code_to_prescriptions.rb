class AddPatientCodeToPrescriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :prescriptions, :patient_code, :string
  end
end
