FactoryBot.define do
  factory :kid do
    association :team
    name { "MyString" }
    sex { "MyString" }
    phone { "MyString" }
    grade { "MyString" }
    attendace_status { 1 }
    attendance_note { "MyString" }
  end
end
