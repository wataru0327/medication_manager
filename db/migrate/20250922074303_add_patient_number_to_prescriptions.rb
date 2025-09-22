class AddPatientNumberToPrescriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :prescriptions, :patient_number, :string
  end
end
