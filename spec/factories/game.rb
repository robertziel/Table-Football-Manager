# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email { Faker::Internet.email }
    password 'password123'
  end
end
