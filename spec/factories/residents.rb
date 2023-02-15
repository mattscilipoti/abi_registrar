require 'faker'

FactoryBot.define do
  factory :resident do
    first_name { Faker::Name.first_name }
    middle_name { 'TEST' }
    last_name { Faker::Name.last_name }
    email_address { Faker::Internet.email }
    phone { "555#{rand(100..999)}#{rand(1000..9999)}" }

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.zone.now) }

    trait :minor do
      is_minor { true }
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
