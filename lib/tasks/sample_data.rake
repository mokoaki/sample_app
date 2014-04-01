namespace :db do
  desc "Fill database with sample data"

  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name: "mokoaki", email: "mokoriso@gmail.com", password: "hogehoge", password_confirmation: "hogehoge", admin: true)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.jp"
    password  = "password#{n+1}"

    User.create!(name: name, email: email, password: password, password_confirmation: password)
  end
end

def make_microposts
  users = User.limit(6)

  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.where(nil)
  user  = users.first

  followed_users = users[2..50]
  followers      = users[3..40]

  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end
