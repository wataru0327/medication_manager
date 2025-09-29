class MedicationIntake < ApplicationRecord
  belongs_to :user
  belongs_to :prescription_item

  validates :taken_at, presence: true
end
