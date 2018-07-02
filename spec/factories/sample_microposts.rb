FactoryBot.define do
  # 自分のマイクロポスト
  factory :user_post, class: Micropost do
    content { Faker::Lorem.sentence(5) }
    # user # or
    association :user, factory: :user
    # association :[モデル名], factory: :[任意につけた名前]
  end
  # 他人のマイクロポスト
  factory :other_user_post, class: Micropost do
    content { Faker::Lorem.sentence(5) }
    # other_user  # or
    association :user, factory: :other_user
  end
end
