class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { doctor: 0, pharmacy: 1, patient: 2 }

  has_many :prescriptions, foreign_key: :doctor_id, class_name: "Prescription"
  has_many :prescriptions_as_patient, foreign_key: :patient_id, class_name: "Prescription"
  has_many :status_updates, foreign_key: :pharmacy_id
end


