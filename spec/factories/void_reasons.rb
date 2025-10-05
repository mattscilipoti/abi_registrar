FactoryBot.define do
  factory :void_reason do
    sequence(:label) { |n| "Reason #{n}" }
    sequence(:code)  { |n| "reason_#{n}" }
    active { true }
    requires_note { false }
    position { nil }
    pass_type { nil }

    trait :other do
      label { 'Other' }
      code { 'other' }
      requires_note { true }
      position { 9999 }
    end

    trait :for_beach_pass do
      pass_type { 'BeachPass' }
    end
  end
end
