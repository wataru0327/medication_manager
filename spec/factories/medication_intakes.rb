FactoryBot.define do
  factory :medication_intake do
    association :user, factory: :user, role: :patient
    association :prescription_item
    taken_at { Time.current }
  end
end
