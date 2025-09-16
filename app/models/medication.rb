class Medication < ApplicationRecord
  belongs_to :prescription

  enum timing: { morning: 0, noon: 1, evening: 2, bedtime: 3 }

  validates :name, :dosage, :timing, presence: true
end

