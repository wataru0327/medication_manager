class CreateStatusUpdates < ActiveRecord::Migration[7.1]
  def change
    create_table :status_updates do |t|
      t.integer :prescription_id
      t.integer :pharmacy_id
      t.integer :status

      t.timestamps
    end
  end
end
