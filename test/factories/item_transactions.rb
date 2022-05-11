FactoryBot.define do
  factory :item_transaction do
    type { "ItemTransaction" }
    activity { :purchase }
    cost_per { rand(100) }
    quantity { rand(100) }
    transacted_at { Faker::Time.between(from: 1.year.ago, to: Time.now) }
    created_at { Faker::Time.between(from: 1.year.ago, to: 1.week.ago) }
    updated_at { Faker::Time.between(from: created_at, to: Time.now) }

    trait :purchase do
      activity { :purchase }
    end

    trait :transfer do
      activity { :transfer }
    end

    trait :with_residency do
      residency
    end

    factory :share_transaction, class: 'ShareTransaction' do
      type { "ShareTransaction" }
      cost_per { 50.00 }
    end
  end
end
