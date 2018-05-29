FactoryBot.define do

  factory :user do
    name     "Example user"
    email    "user@example.com"
    password              "foobar"
    password_confirmation "foobar"
    admin false
  end

  factory :admin_user, class: User do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
    admin true
  end

  factory :admin_user2, class: User do
    name     "shuhei tanabe"
    email    "shuhei.tanabe0130@gmail.com"
    password              "foobar"
    password_confirmation "foobar"
    admin true
  end

  factory :sequence_user, class: User do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password              "foobar"
    password_confirmation "foobar"
    admin false
  end

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
