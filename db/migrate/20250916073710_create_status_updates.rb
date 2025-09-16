class CreateStatusUpdates < ActiveRecord::Migration[7.1]
  def change
    create_table :status_updates do |t|
      t.references :prescription, null: false, foreign_key: true
      t.references :pharmacy, null: false, foreign_key: { to_table: :users }
      t.integer :status, null: false # enum (pending, processing, completed)

      t.timestamps
    end
  end
end

