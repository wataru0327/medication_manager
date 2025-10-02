FactoryBot.define do
  factory :qr_scan do
    association :user, factory: [:user, :pharmacy]
    association :prescription
    token { SecureRandom.hex(10) }
  end
end
