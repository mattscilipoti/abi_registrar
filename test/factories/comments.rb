FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence } 

    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.now) }

  end
end
