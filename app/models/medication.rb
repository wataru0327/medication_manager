# app/models/medication.rb
class Medication < ApplicationRecord
  # 画像添付（ActiveStorage）
  has_one_attached :image

  # 服用タイミング
  enum timing: {
    morning: 0,    # 朝
    noon: 1,       # 昼
    evening: 2,    # 夕方
    bedtime: 3,    # 就寝前
    after_meal: 4  # 毎食後
  }

  # 薬の目的
  enum purpose: {
    unspecified: 0, # 未設定
    antipyretic: 1, # 解熱
    analgesic: 2,   # 鎮痛
    stomach: 3,     # 胃薬
    antibiotic: 4   # 抗生物質
  }

  # バリデーション
  validates :name, presence: true
  validates :dosage, presence: true
  validates :timing, presence: true
  validates :purpose, presence: true

  # ActiveStorage の画像必須チェック
  validate :image_attached

  private

  def image_attached
    errors.add(:image, "を選択してください") unless image.attached?
  end
end



