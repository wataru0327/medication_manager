FactoryBot.define do
  factory :status_update do
    association :prescription
    association :pharmacy, factory: :user, role: :pharmacy
    status { :pending }
  end
end
