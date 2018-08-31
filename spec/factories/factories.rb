# FactoryBot.define do
#   # 自分
#   # factory [任意のファクトリ名], class: [モデル名]
#   factory :user, class: User do
#     name     "Example user"
#     email    "user@example.com"
#     password              "foobar"
#     password_confirmation "foobar"
#     admin false
#
#     # 自分のマイクロポスト
#     factory :user_post, class: Micropost do
#       content { Faker::Lorem.sentence(5) }
#       # 関連づけられたファクトリ名
#       user
#       # 今日、投稿されたマイクロポスト
#       trait :today do
#         created_at 1.hour.ago
#       end
#       # 昨日、投稿されたマイクロポスト
#       trait :yesterday do
#         created_at 1.day.ago
#       end
#     end
#   end
#   # 他人
#   factory :other_user, class: User do
#     name { Faker::Name.name }
#     email { Faker::Internet.email }
#     password              "foobar"
#     password_confirmation "foobar"
#     admin false
#     # 他人のマイクロポスト
#     factory :other_user_post, class: Micropost do
#       content { Faker::Lorem.sentence(5) }
#       # 関連づけられたファクトリ名
#       other_user
#     end
#   end
#   # 管理者ユーザ
#   factory :admin, class: User do
#     name     "Michael Hartl"
#     email    "michael@example.com"
#     password "foobar"
#     password_confirmation "foobar"
#     admin true
#   end
# end





# FactoryBot.define do
#   # 自分
#   # factory [任意のファクトリ名], class: [モデル名]
#   factory :user, class: User do
#     name     "Example user"
#     email    "user@example.com"
#     password              "foobar"
#     password_confirmation "foobar"
#     admin false
#
#     # 自分のマイクロポスト
#     factory :user_post, class: Micropost do
#       content { Faker::Lorem.sentence(5) }
#       # association :[モデル名], factory: :[ファクトリ名]
#       association :user, factory: :user
#
#       # 今日、投稿されたマイクロポスト
#       trait :today do
#         created_at 1.hour.ago
#       end
#       # 昨日、投稿されたマイクロポスト
#       trait :yesterday do
#         created_at 1.day.ago
#       end
#     end
#   end
#   # 他人
#   factory :other_user, class: User do
#     name { Faker::Name.name }
#     email { Faker::Internet.email }
#     password              "foobar"
#     password_confirmation "foobar"
#     admin false
#     # 他人のマイクロポスト
#     factory :other_user_post, class: Micropost do
#       content { Faker::Lorem.sentence(5) }
#       association :user, factory: :other_user
#     end
#   end
#   # 管理者ユーザ
#   factory :admin, class: User do
#     name     "Michael Hartl"
#     email    "michael@example.com"
#     password "foobar"
#     password_confirmation "foobar"
#     admin true
#   end
# end
