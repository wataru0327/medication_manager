class StatusUpdate < ApplicationRecord
  belongs_to :prescription
  belongs_to :pharmacy, class_name: "User"

  enum status: { pending: 0, processing: 1, completed: 2 }

  validates :prescription_id, :pharmacy_id, :status, presence: true
end

