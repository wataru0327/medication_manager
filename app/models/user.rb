class User < ApplicationRecord
  # Devise のモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ロール定義
  enum role: { doctor: 0, pharmacy: 1, patient: 2 }

  # 関連付け
  has_many :doctor_prescriptions, class_name: "Prescription", foreign_key: :doctor_id, dependent: :destroy, inverse_of: :doctor
  has_many :patient_prescriptions, class_name: "Prescription", foreign_key: :patient_id, dependent: :destroy, inverse_of: :patient
  has_many :status_updates, foreign_key: :pharmacy_id, dependent: :destroy, inverse_of: :pharmacy

  # バリデーション
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
