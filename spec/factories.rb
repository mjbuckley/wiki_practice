FactoryGirl.define do
  factory :user do
    name     "Michael Buckley"
    email    "michael@example.com"
    password "foobarfoo"
    password_confirmation "foobarfoo"
  end
end