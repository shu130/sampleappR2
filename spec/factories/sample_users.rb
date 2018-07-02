FactoryBot.define do

  factory :user, class: User do
    name     "Example user"
    email    "user@example.com"
    # エラー対応 Validation failed: Email has already been taken
    initialize_with { User.find_or_create_by(email: email) }
    password              "foobar"
    password_confirmation "foobar"
    admin false
  end

  factory :other_user, class: User do
    # sequence(:name)  { |n| "Person #{n}" }
    # sequence(:email) { |n| "person_#{n}@example.com"}
    # or
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password              "password"
    password_confirmation "password"
    admin false
  end

  factory :admin, class: User do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
    admin true
  end

  # factory :admin_user, class: User do
  #   name     "shuhei tanabe"
  #   email    "shuhei.tanabe0130@gmail.com"
  #   password              "foobar"
  #   password_confirmation "foobar"
  #   admin true
  # end


  # factory :user do
  #   sequence(:name)  { |n| "Person #{n}" }
  #   sequence(:email) { |n| "person_#{n}@example.com"}
  #
  #   # email { Faker::Internet.email }
  #   # name { Faker::Name.name }
  #
  #   password "foobar"
  #   password_confirmation "foobar"
  #
  #   admin false
  #
  #   # factory :admin_user do
  #   #   admin true
  #   # end
  # end
end
