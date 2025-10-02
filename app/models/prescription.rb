class Prescription < ApplicationRecord
  # 関連付け
  belongs_to :patient, class_name: "User"   
  belongs_to :doctor, class_name: "User"

  has_many :prescription_items, dependent: :destroy
  has_many :medications, through: :prescription_items
  has_many :status_updates, dependent: :destroy
  has_many :qr_scans, dependent: :destroy   

  accepts_nested_attributes_for :prescription_items, allow_destroy: true

  # バリデーション
  validates :patient_id, :doctor_id, :hospital_name, :issued_at, :expires_at, :qr_token, presence: true
  validates :qr_token, uniqueness: true

  # 患者名は必須（空欄NG、50文字以内）
  validates :patient_name, presence: true, length: { maximum: 50 }

  # ✅ 処方薬が最低1つ必要（独自バリデーションでチェック）
  validate :must_have_prescription_items
  validate :expires_after_issued

  private

  # 有効期限チェック
  def expires_after_issued
    if expires_at.present? && issued_at.present? && expires_at <= issued_at
      errors.add(:expires_at, "は発行日より後の日付にしてください")
    end
  end

  # 処方薬必須チェック
  def must_have_prescription_items
    if prescription_items.blank?
      errors.add(:base, "処方箋アイテムを入力してください")
    end
  end
end






