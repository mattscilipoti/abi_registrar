FactoryBot.define do
  factory :item_transaction do
    type { "" }
    cost_per { "" }
    quantity { 1 }
    cost_total { "" }
    resident { nil }
  end
end
