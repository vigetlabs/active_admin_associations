# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_user do
    sequence(:email) {|n| "admin#{n}@example.com" }
    password 'BaudP0wer!'
    password_confirmation 'BaudP0wer!'
  end
end
