FactoryBot.define do
  factory :prescription_item do
    association :prescription
    association :medication
    days { 7 }
  end
end
