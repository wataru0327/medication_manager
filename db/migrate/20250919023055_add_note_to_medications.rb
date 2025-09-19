class AddNoteToMedications < ActiveRecord::Migration[7.1]
  def change
    add_column :medications, :note, :text
    # 🚫 image カラムは不要（ActiveStorageで管理するから）
  end
end
