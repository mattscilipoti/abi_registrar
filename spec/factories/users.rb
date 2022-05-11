FactoryBot.define do
  factory :user do
    email { Faker::Internet.email(domain: 'example') }
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
