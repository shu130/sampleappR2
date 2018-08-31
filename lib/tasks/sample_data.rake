namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name: "shuhei.tanabe",
                       email: "shuhei.tanabe0130@gmail.com",
                       password: "foobar",
                       password_confirmation: "foobar",
                       admin: true)

  # admin = User.create!(name:     "Example User",
  #                      email:    "example@railstutorial.jp",
  #                      password: "foobar",
  #                      password_confirmation: "foobar",
  #                      admin: true)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.jp"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  # users = User.all(limit: 6) # or
  users = User.order(:created_at).take(6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  # 最初のユーザーに ユーザ3〜51 までをフォローさせ、
  # 逆に ユーザ4〜41 に 最初のユーザーをフォローさせる
  users = User.all
  user  = users.first
  # followed_users = users[2..50]
  following      = users[2..50]
  followers      = users[3..40]
  # followed_users.each { |followed| user.follow!(followed) }
  following.each { |following| user.follow(following) }
  followers.each { |follower| follower.follow(user) }
end




# namespace :db do
#   desc "Fill database with sample data"
#
#   task populate: :environment do
#
#     User.create!(name: "shuhei.tanabe",
#                  email: "shuhei.tanabe0130@gmail.com",
#                  password: "foobar",
#                  password_confirmation: "foobar",
#                  admin: true)
#
#     99.times do |n|
#       name  = Faker::Name.name
#       email = "example-#{n+1}@railstutorial.jp"
#
#       # name { Faker::Name.name }
#       # email { Faker::Internet.email }
#
#       password  = "password"
#
#       User.create!(name: name,
#                    email: email,
#                    password: password,
#                    password_confirmation: password,
#                    admin: false)
#     end
#
#     # users = User.all(limit: 6) # or
#     users = User.order(:created_at).take(6)
#     50.times do
#       content = Faker::Lorem.sentence(5)
#       users.each { |user| user.microposts.create!(content: content) }
#     end
#   end
# end
