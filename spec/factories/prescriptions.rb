FactoryBot.define do
  factory :prescription do
    association :doctor,  factory: [:user, :doctor],  strategy: :create
    association :patient, factory: [:user, :patient], strategy: :create

    patient_name  { "テスト患者" }
    hospital_name { "テスト病院" }
    issued_at     { Date.today }
    expires_at    { Date.tomorrow }
    qr_token      { SecureRandom.uuid }

    after(:build) do |prescription|
      prescription.prescription_items << build(
        :prescription_item,
        prescription: prescription,
        medication: build(:medication, :with_image)  
      )
    end
  end
end
