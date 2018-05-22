

# chap06
# アウトライン

# :name
  describe "when name is not present"
  describe "when name is too long"
# :email
  describe "when email is not present"
  describe "when email is too long"
  describe "when email format is invalid"
  describe "when email format is valid"
  describe "when email address is already taken"
  describe "when email address is mixed case"
# :password
  describe "when password is not present"
  describe "when password doesn't match confirmation"
  describe "when password is too short"
  describe "returen value of authenticate method"

User
  should respond to #name
  should respond to #email
  should respond to #password_digest
  should respond to #authenticate
  when name is not present
    should not be valid
  when name is too long
    should not be valid
  when email is not present
    should not be valid
  when email format is invalid
    should be invalid
  when email format is valid
    should be valid
  when email address is already taken
    should not be valid
  when email address is mixed-case
    should be saved as lower-case
  when password is not present
    should not be valid
  when password doesnt match confirmation
    should not be valid
  when password is too short
    should not be valid
  returen value of authenticate method
    with valid password
      should eq #<User id: 1, name: "Example User", email: "user@example.com", created_at: "2018-05-22 13:22:53", upd...at: "2018-05-22 13:22:53", password_digest: "$2a$04$boNAg4thVEpjdviEFVk6m..ilHynTYKl2UtiwKS.mXt...">
    with invalid password
      should not eq false
      should be falsey

Finished in 0.57179 seconds (files took 1.41 seconds to load)
17 examples, 0 failures


# chap06
spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = User.new(name: "Example User",
                     email: "user@example.com",
                     password: "foobar",
                     password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:authenticate) }

  # :name

  describe "when name is not present" do
    before { @user.name = "   " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  # :email

  describe "when email is not present" do
    before { @user.email = "   " }
    it { should_not be_valid }
  end

  describe "when email is too long" do
    before { @user.email = "a" * 255 + "@example.com" }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                       foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_email|
        @user.email = invalid_email
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_email|
        @user.email = valid_email
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      same_email_user = @user.dup
      same_email_user.email = @user.email.upcase
      same_email_user.save
    end

    it { should_not be_valid }
  end

  describe "when email address is mixed-case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  # :password

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User",
                       email: "user@example.com",
                       password: " ",
                       password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  describe "returen value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    context "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
    context "with invalid password" do
      let(:user_invalid_pwd) { found_user.authenticate("invalid") }

      it { should_not eq user_invalid_pwd }
      it { expect(user_invalid_pwd).to be_falsey }
    end
  end

end
