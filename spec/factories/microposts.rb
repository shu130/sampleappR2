FactoryBot.define do
  # 自分のマイクロポスト
  factory :user_post, class: Micropost do
    content { Faker::Lorem.sentence(5) }
    # association :[関連するモデル名], factory: :[任意につけたファクトリ名]
    association :user, factory: :user  # or
    # 任意につけたファクトリ名
    # user

    # 今日、投稿されたマイクロポスト
    trait :today do
      created_at 1.hour.ago
    end
    # 昨日、投稿されたマイクロポスト
    trait :yesterday do
      created_at 1.day.ago
    end

    # 他人のマイクロポスト
    factory :other_user_post do
      content { Faker::Lorem.sentence(5) }
      association :user, factory: :other_user
    end
  end
end




# FactoryBot.define do
#   # 自分のマイクロポスト
#   factory :user_post, class: Micropost do
#     content { Faker::Lorem.sentence(5) }
#     # user
#     # or
#     association :user, factory: :user
#     # => association :[モデル名], factory: :[任意につけた名前]
#
#     # 今日、投稿されたマイクロポスト
#     trait :today do
#       created_at 1.hour.ago
#     end
#     # 昨日、投稿されたマイクロポスト
#     trait :yesterday do
#       created_at 1.day.ago
#     end
#   end
#   # 他人のマイクロポスト
#   factory :other_user_post, class: Micropost do
#     content { Faker::Lorem.sentence(5) }
#     # other_user  # or
#     association :user, factory: :other_user
#   end
# end




# FactoryBot.define do
#   # 自分のマイクロポスト
#   factory :user_post, class: Micropost do
#     content { Faker::Lorem.sentence(5) }
#     # user # or
#     association :user, factory: :user
#     # association :[モデル名], factory: :[任意につけた名前]
#
#     # 他人のマイクロポスト
#     factory :other_user_post do
#       content { Faker::Lorem.sentence(5) }
#       # # other_user  # or
#       # association :user, factory: :other_user
#     end
#   end
# end
