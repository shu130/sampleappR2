
# chap09
リスト9.38 admin属性に対するテスト


# chap08
リスト8.15 記憶トークン用の最初のテスト
リスト8.17 記憶トークンが有効である (空欄のない) ことをテスト


# chap07
# なし


# list
リスト6.4 実質的に空になっているデフォルトのUser spec
リスト6.5 :nameと:email属性
リスト6.8 name属性の検証に対する、失敗するテスト
リスト6.9 email属性の存在性のテスト
リスト6.11 nameの長さ検証のテスト
リスト6.13 メールアドレスフォーマットの検証テスト
リスト6.15 重複するメールアドレスの拒否のテスト
リスト6.17 大文字小文字を区別しない、重複するメールアドレスの拒否のテスト
リスト6.22 Userオブジェクトにpassword_digestカラムがあることを確認するテスト
リスト6.24 password属性とpassword_confirmation属性をテスト
リスト6.25 パスワードとパスワードの確認をテスト
リスト6.28 パスワードの長さとauthenticateメソッドをテスト
リスト6.30 リスト6.20のメールアドレス小文字変換をテスト

# chap06

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



# chap06_bkup
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
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:password_digest) }

  # 存在性 presence
  describe "when name is not present" do
    before { @user.name = "   " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = "   " }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation =  "  " }
    it { should_not be_valid }
  end

  # 文字数
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email is too long" do
    before { @user.email = "a" * 255 + "@example.com" }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation "a" * 5 }
    it { should_not be_valid }
  end

  # email のフォーマット
  describe "when email format is invalid" do
    it "should be invalid" do
      invalid_addr = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      invalid_addr.each do |addr|
        @user.email = addr
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      valid_addr = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      valid_addr.each do |addr|
        @user.email = addr
        expect(@user).to be_valid
      end
    end
  end

  # email 一意性 unique
  describe "when email address is already taken" do
    before do
      dup_user = @user.dup
      dup_user.email = @user.email.upcase
      dup_user.save
    end
    it { should_not be_valid }
  end

  # email の beforeフィルタ
  describe "when email address is mixed-case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
    it "should be saved as lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  # :password_confirmation
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  # パスワード認証 authenticate
  describe "returen value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    context "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
    context "with invalid password" do
      let(:incorrect) { found_user.authenticate("invalid") }
      it { should_not eq incorrect }
      it { expect(incorrect).to be_falsey }
    end
  end

end





# # shoulda-matcher の試行錯誤
# require 'rails_helper'
#
# RSpec.describe User, type: :model do
#
#   # let(:user) { FactoryBot.build(:user) }
#   # subject { user }
#
#   subject { FactoryBot.build(:user) }
#
#   it { should respond_to(:name) }
#   it { should respond_to(:email) }
#   it { should respond_to(:password_digest) }
#   it { should respond_to(:password) }
#   it { should respond_to(:password_confirmation) }
#   it { should respond_to(:authenticate) }
#   # it { should respond_to(:remember_digest) }
#   # it { should respond_to(:admin) }
#
#   it { should be_valid }
#   # it { should_not be_admin }
#
#   describe 'validations' do
#     # subject { FactoryBot.build(:user, password: "") }
#
#     it do
#       is_expected.to validate_presence_of(:name)
#       is_expected.to validate_presence_of(:email)
#       is_expected.to validate_presence_of(:password)
#       is_expected.to validate_uniqueness_of(:email).case_insensitive
#     end
#   end
#
# end
#
# エラー対応
# Failures:
#
#   1) User validations should validate that :password cannot be empty/falsy
#      Failure/Error: is_expected.to validate_presence_of(:password)
#
#      Shoulda::Matchers::ActiveModel::CouldNotSetPasswordError:
#        The validation failed because your User model declares `has_secure_password`, and
#        `validate_presence_of` was called on a user which has `password` already set to a value.
#        Please use a user with an empty `password` instead.
#
# 対応はここに
# https://github.com/thoughtbot/shoulda-matchers/blob/master/lib/shoulda/matchers/active_model/validate_presence_of_matcher.rb
