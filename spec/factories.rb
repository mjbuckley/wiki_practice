FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobarfoo"
    password_confirmation "foobarfoo"

    factory :admin do
      admin true
    end
  end

  factory :review do
    rating 3
    user
    page_id 123
    rev_id 1234567
    comment "lorem ipsum"
    title "page title"
  end
end
