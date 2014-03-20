namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "mokoaki", email: "mokoriso@gmail.com", password: "hogehoge", password_confirmation: "hogehoge", admin: true)

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.jp"
      password  = "password"

      User.create!(name: name, email: email, password: password, password_confirmation: password)
    end
  end
end
