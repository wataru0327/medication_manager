class AddHospitalNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :hospital_name, :string
  end
end
