FactoryBot.define do
  factory :medication do
    name { "ロキソニン" }
    dosage { "1錠" }
    timing { :morning }
    purpose { :analgesic }
    note { "食後30分以内に服用してください" }
  end
end
