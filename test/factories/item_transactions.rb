FactoryBot.define do
  factory :item_transaction do
    type { "" }
    activity { :purchase }
    cost_per { rand(100) }
    quantity { rand(100) }
    transacted_at { Time.now }

    trait :purchase do
      activity { :purchase }
    end

    trait :transfer do
      activity { :transfer }
    end

    trait :with_residency do
      residency
    end

    factory :share_transaction do
      type { "ShareTransaction" }
      cost_per { 50.00 }
    end
  end
end
