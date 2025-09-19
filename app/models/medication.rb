class Medication < ApplicationRecord
  has_one_attached :image

  # 服用タイミング
  enum timing: {
    morning: 0,   # 朝
    noon: 1,      # 昼
    evening: 2,   # 夕方
    bedtime: 3,   # 就寝前
    after_meal: 4 # 毎食後
  }

  enum purpose: {
    unspecified: 0, # 未設定
    antipyretic: 1, # 解熱
    analgesic: 2,   # 鎮痛
    stomach: 3,     # 胃薬
    antibiotic: 4   # 抗生物質
  }

  validates :name, :dosage, :timing, presence: true
end



