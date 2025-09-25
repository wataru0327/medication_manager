class ChangePharmacyIdNullableInStatusUpdates < ActiveRecord::Migration[7.0]
  def change
    change_column_null :status_updates, :pharmacy_id, true
  end
end
