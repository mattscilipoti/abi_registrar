FactoryBot.define do
  factory :purchase do
    type { "" }
    cost_per { "" }
    quantity { 1 }
    cost_total { "" }
    resident { nil }
  end
end
