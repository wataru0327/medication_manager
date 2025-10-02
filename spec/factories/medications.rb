# spec/factories/medications.rb
FactoryBot.define do
  factory :medication do
    name { "ロキソニン" }
    dosage { "1錠" }
    timing { :morning }
    purpose { :analgesic }

    trait :with_image do
      after(:build) do |med|
        med.image.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/test_image.png")),
          filename: "test_image.png",
          content_type: "image/png"
        )
      end
    end
  end
end

