FactoryBot.define do
  factory :property do
    street_number { Faker::Address.building_number }
    street_name { Faker::Address.street_name }
    
    transient do
      lots_count { 1 }
    end
    
    after(:create) do |property, evaluator|
      create_list(:lot, evaluator.lots_count, property: property)
    end
  end
end