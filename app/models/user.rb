class User < ApplicationRecord
  enum role: { doctor: 0, pharmacy: 1, patient: 2 }

  has_many :prescriptions, foreign_key: :doctor_id, dependent: :destroy, inverse_of: :doctor
  has_many :prescriptions, foreign_key: :patient_id, dependent: :destroy, inverse_of: :patient
  has_many :status_updates, foreign_key: :pharmacy_id, dependent: :destroy, inverse_of: :pharmacy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
