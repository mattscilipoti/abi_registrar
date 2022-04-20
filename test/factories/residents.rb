require 'faker'

FactoryBot.define do
  factory :resident do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email_address { Faker::Internet.email }

    trait :minor do
      is_minor { true }
      age_of_minor { rand(1..13) }
    end

    trait :verified do
      verified_at { 1.minute.ago }
    end

    trait :with_properties do
      transient do
        properties_count { 2 }
      end
  
      properties do
        Array.new(properties_count) { association(:property) }
      end

    end
  end
end