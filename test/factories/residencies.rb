require 'faker'

FactoryBot.define do
  factory :residency do
    property
    resident
    resident_status { :deed_holder }
  end

  trait :verified do
    verified_on { 1.minute.ago }
  end
end