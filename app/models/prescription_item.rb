# app/models/prescription_item.rb
class PrescriptionItem < ApplicationRecord
  belongs_to :prescription
  belongs_to :medication

  validates :days, numericality: { only_integer: true, greater_than: 0 }
end

