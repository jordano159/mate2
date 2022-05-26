FactoryBot.define do
  factory :organizational_unit do
    association :team
    name { "MyString" }
    level_name { "MyString" }
    level_index { 1 }
  end
end
