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

  # remember_digest
  describe "remember digest" do
    before { @user.save }
    its(:remember_digest) { should_not be_blank }
  end


end
