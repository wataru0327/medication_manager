FactoryBot.define do
  factory :prescription_item do
    association :prescription
    association :medication
    days { 7 }
    dosage { "1錠" }
    timing { "朝夕食後" }
  end
end

