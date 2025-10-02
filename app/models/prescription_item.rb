# app/models/prescription_item.rb
class PrescriptionItem < ApplicationRecord
  belongs_to :prescription
  belongs_to :medication

  has_many :medication_intakes, dependent: :destroy

  validates :days, numericality: { only_integer: true, greater_than: 0 }
end

