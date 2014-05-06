namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
                         email: "example@example.com",
                         password: "foobarfoo",
                         password_confirmation: "foobarfoo",
                         admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@example.com"
      password  = "foobarfoo"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 6)
    3.times do
      rating = rand(1..5)
      page = rand(100..999)
      rev = rand(100000..999999)
      comment = Faker::Lorem.sentence(5)
      title = "page" + page.to_s
      users.each { |user| user.reviews.create!(rating: rating, page_id: page, rev_id: rev, comment: comment, title: title) }
    end
  end
end
