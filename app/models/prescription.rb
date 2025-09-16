class Prescription < ApplicationRecord
  belongs_to :patient, class_name: "User"
  belongs_to :doctor, class_name: "User"
  has_many :medications, dependent: :destroy
  has_many :status_updates, dependent: :destroy

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

