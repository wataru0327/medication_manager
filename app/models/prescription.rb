# app/models/prescription.rb
class Prescription < ApplicationRecord
  belongs_to :patient, class_name: "User"
  belongs_to :doctor, class_name: "User"

  has_many :prescription_items, dependent: :destroy
  has_many :medications, through: :prescription_items
  has_many :status_updates, dependent: :destroy

  accepts_nested_attributes_for :prescription_items, allow_destroy: true

  validates :patient_id, :doctor_id, :issued_at, :expires_at, :qr_token, presence: true
  validates :qr_token, uniqueness: true
  validate :expires_after_issued

  private

  def expires_after_issued
    if expires_at.present? && issued_at.present? && expires_at <= issued_at
      errors.add(:expires_at, "must be later than issued_at")
    end
  end
end

# app/models/medication.rb
class Medication < ApplicationRecord
  has_many :prescription_items
  has_many :prescriptions, through: :prescription_items
end

# app/models/prescription_item.rb
class PrescriptionItem < ApplicationRecord
  belongs_to :prescription
  belongs_to :medication

  validates :days, numericality: { only_integer: true, greater_than: 0 }
end


