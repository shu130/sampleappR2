# User.create!(name:  "Example User",
#              email: "example@railstutorial.org",
#              password:              "foobar",
#              password_confirmation: "foobar",
#              admin: true)
#
# 99.times do |n|
#   name  = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name:  name,
#                email: email,
#                password:              password,
#                password_confirmation: password)
# end


# require 'factory_bot'
# Dir[Rails.root.join('spec/factories/*.rb')].each {|f| require f }
#
# User.delete_all
#
# FactoryBot.create_list(:admin_user)
# FactoryBot.create_list(:admin_user2)
# FactoryBot.create_list(:user, 50)
