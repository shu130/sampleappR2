# FactoryBot.define do
#
#   factory :user, class: User do
#     name     "Example user"
#     email    "user@example.com"
#     # エラー対応 Validation failed: Email has already been taken
#     initialize_with { User.find_or_create_by(email: email) }
#     password              "foobar"
#     password_confirmation "foobar"
#     admin false
#
#     # 自分のマイクロポスト
#     factory :user_post, class: Micropost do
#       content { Faker::Lorem.sentence(5) }
#       # user # or
#       association :user, factory: :user
#       # association :[モデル名], factory: :[データ名]
#     end
#   end
#
#   factory :other_user, class: User do
#     name { Faker::Name.name }
#     email { Faker::Internet.email }
#     password              "password"
#     password_confirmation "password"
#     admin false
#
#     # 他人のマイクロポスト
#     factory :other_user_post, class: Micropost do
#       content { Faker::Lorem.sentence(5) }
#       # other_user  # or
#       association :user, factory: :other_user
#     end
#   end
#
#   factory :admin, class: User do
#     name     "Michael Hartl"
#     email    "michael@example.com"
#     password "foobar"
#     password_confirmation "foobar"
#     admin true
#   end
# end
