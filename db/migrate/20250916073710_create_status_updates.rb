class CreateStatusUpdates < ActiveRecord::Migration[7.1]
  def change
    create_table :status_updates do |t|
      t.references :prescription, null: false, foreign_key: true
      t.references :pharmacy, foreign_key: { to_table: :users }
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
