namespace :db do
  desc "Fill database with sample data"

  task populate: :environment do

    # admin = User.create!(name: "shuhei.tanabe",
    #                      email: "shuhei.tanabe0130@gmail.com",
    #                      password: "foobar",
    #                      password_confirmation: "foobar",
    #                      admin: true)

    User.create!(name: "shuhei.tanabe",
                 email: "shuhei.tanabe0130@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.jp"

      # name { Faker::Name.name }
      # email { Faker::Internet.email }

      password  = "password"

      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
