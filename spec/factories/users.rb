FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    role { :doctor }

    trait :doctor do
      role { :doctor }
    end

    trait :pharmacy do
      role { :pharmacy }
    end

    trait :patient do
      role { :patient }
      sequence(:patient_number) { |n| n }  
    end
  end
end
