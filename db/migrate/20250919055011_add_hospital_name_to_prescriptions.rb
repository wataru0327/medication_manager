class AddHospitalNameToPrescriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :prescriptions, :hospital_name, :string
  end
end
