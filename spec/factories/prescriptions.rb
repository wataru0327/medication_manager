FactoryBot.define do
  factory :prescription do
    association :doctor, factory: :user, role: :doctor
    association :patient, factory: :user, role: :patient
    patient_name { "テスト患者" }
    issued_at { Date.today }
    expires_at { Date.tomorrow }
    qr_token { SecureRandom.uuid }
  end
end

