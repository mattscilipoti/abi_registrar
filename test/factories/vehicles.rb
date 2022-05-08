FactoryBot.define do
  factory :vehicle do
    tag_number { "MyString" }
    sticker_number { 1 }
    resident { nil }
  end
end
