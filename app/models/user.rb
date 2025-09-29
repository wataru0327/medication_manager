class User < ApplicationRecord
  # Devise のモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ロール定義
  enum role: { doctor: 0, pharmacy: 1, patient: 2 }

  # 関連付け
  has_many :doctor_prescriptions,
           class_name: "Prescription",
           foreign_key: :doctor_id,
           dependent: :destroy,
           inverse_of: :doctor

  has_many :patient_prescriptions,
           class_name: "Prescription",
           foreign_key: :patient_id,
           dependent: :destroy,
           inverse_of: :patient

  has_many :status_updates,
           foreign_key: :pharmacy_id,
           dependent: :destroy,
           inverse_of: :pharmacy

  # 👇 QRコード読み取り履歴
  has_many :qr_scans, dependent: :destroy

  # 👇 飲み忘れ防止チェック（服薬記録）
  has_many :medication_intakes, dependent: :destroy

  # バリデーション
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :patient_number, uniqueness: true, allow_nil: true

  # コールバック（患者のみ patient_number を自動採番）
  before_create :assign_patient_number, if: :patient?

  private

  def assign_patient_number
    last_number = User.where(role: :patient).maximum(:patient_number) || 0
    self.patient_number = last_number + 1
  end
end


