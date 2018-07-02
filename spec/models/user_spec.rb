require 'rails_helper'

RSpec.describe User, type: :model do

  # before do
  #   @user = User.new(name: "Example User",
  #                    email: "user@example.com",
  #                    password: "foobar",
  #                    password_confirmation: "foobar")
  # end
  let(:user) { build(:user) }
  subject { user }

  it_behaves_like "User-model respond to attribute or method"
  # it { should respond_to(:name) }
  # it { should respond_to(:email) }
  # it { should respond_to(:password) }
  # it { should respond_to(:password_confirmation) }
  # it { should respond_to(:authenticate) }
  # it { should respond_to(:password_digest) }
  # it { should respond_to(:remember_digest) }
  # it { should respond_to(:activation_digest) }

  # ボツ
  # # 存在性 presence
  # it_behaves_like "non-presence", name
  # it_behaves_like "non-presence", email
  # it_behaves_like "non-presence", password
  # it_behaves_like "non-presence", password_confirmation

  # 存在性 presence
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }

  # NG になる
  # it { is_expected.to validate_presence_of :password }
  # it { is_expected.to validate_presence_of :password_confirmation }

  describe "when password is not present" do
    before { user.password = user.password_confirmation =  "  " }
    it { should_not be_valid }
  end

  # 文字数
  describe "when name is too long" do
    before { user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email is too long" do
    before { user.email = "a" * 255 + "@example.com" }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { user.password = user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  # email のフォーマット
  describe "when email format is invalid" do
    it "should be invalid" do
      invalid_addr = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      invalid_addr.each do |addr|
        user.email = addr
        expect(user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      valid_addr = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      valid_addr.each do |addr|
        user.email = addr
        expect(user).to be_valid
      end
    end
  end

  # email 一意性 unique
  describe "when email address is already taken" do
    before do
      dup_user = user.dup
      dup_user.email = user.email.upcase
      dup_user.save
    end
    it { should_not be_valid }
  end

  # email の beforeフィルタ
  describe "when email address is mixed-case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
    it "should be saved as lower-case" do
      user.email = mixed_case_email
      user.save
      expect(user.reload.email).to eq mixed_case_email.downcase
    end
  end

  # :password_confirmation
  describe "when password doesn't match confirmation" do
    before { user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  # パスワード認証 authenticate
  describe "returen value of authenticate method" do
    before { user.save }
    let(:found_user) { User.find_by(email: user.email) }

    context "with valid password" do
      it { should eq found_user.authenticate(user.password) }
    end
    context "with invalid password" do
      let(:incorrect) { found_user.authenticate("invalid") }
      it { should_not eq incorrect }
      it { expect(incorrect).to be_falsey }
    end
  end

  # バグその２対応：異なる種類のブラウザでのログアウト問題

  # モデル側の authenticated?メソッド を 一般化する前

  # # authenticated?メソッド 記憶ダイジェスト の nilガード
  # describe "authenticated? with nil remember_digest" do
  #   # 引数の remember_token には 適当な値をセット
  #   let(:value) { user.authenticated?("foo") }
  #   it { expect(value).to be_falsey }
  # end

  # モデル側の authenticated?メソッド が 一般化された後

  describe "authenticated? with nil remember_digest" do
    let(:value) { user.authenticated?(:remember, "foo") }
    it { expect(value).to be_falsey }
  end

  # describe "authenticated? with nil activation_digest" do
  #   let(:value) { user.authenticated?(:activation, "foo") }
  #   it { expect(value).to be_falsey }
  # end


end



# require 'rails_helper'
#
# RSpec.describe User, type: :model do
#
#   before do
#     @user = User.new(name: "Example User",
#                      email: "user@example.com",
#                      password: "foobar",
#                      password_confirmation: "foobar")
#   end
#
#   subject { @user }
#
#   it { should respond_to(:name) }
#   it { should respond_to(:email) }
#   it { should respond_to(:password) }
#   it { should respond_to(:password_confirmation) }
#   it { should respond_to(:authenticate) }
#   it { should respond_to(:password_digest) }
#   it { should respond_to(:remember_digest) }
#   it { should respond_to(:activation_digest) }
#
#   # 存在性 presence
#   describe "when name is not present" do
#     before { user.name = "   " }
#     it { should_not be_valid }
#   end
#
#   describe "when email is not present" do
#     before { @user.email = "   " }
#     it { should_not be_valid }
#   end
#
#   describe "when password is not present" do
#     before { @user.password = @user.password_confirmation =  "  " }
#     it { should_not be_valid }
#   end
#
#   # 文字数
#   describe "when name is too long" do
#     before { @user.name = "a" * 51 }
#     it { should_not be_valid }
#   end
#
#   describe "when email is too long" do
#     before { @user.email = "a" * 255 + "@example.com" }
#     it { should_not be_valid }
#   end
#
#   describe "when password is too short" do
#     before { @user.password = @user.password_confirmation = "a" * 5 }
#     it { should_not be_valid }
#   end
#
#   # email のフォーマット
#   describe "when email format is invalid" do
#     it "should be invalid" do
#       invalid_addr = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
#       invalid_addr.each do |addr|
#         @user.email = addr
#         expect(@user).not_to be_valid
#       end
#     end
#   end
#
#   describe "when email format is valid" do
#     it "should be valid" do
#       valid_addr = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
#       valid_addr.each do |addr|
#         @user.email = addr
#         expect(@user).to be_valid
#       end
#     end
#   end
#
#   # email 一意性 unique
#   describe "when email address is already taken" do
#     before do
#       dup_user = @user.dup
#       dup_user.email = @user.email.upcase
#       dup_user.save
#     end
#     it { should_not be_valid }
#   end
#
#   # email の beforeフィルタ
#   describe "when email address is mixed-case" do
#     let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
#     it "should be saved as lower-case" do
#       @user.email = mixed_case_email
#       @user.save
#       expect(@user.reload.email).to eq mixed_case_email.downcase
#     end
#   end
#
#   # :password_confirmation
#   describe "when password doesn't match confirmation" do
#     before { @user.password_confirmation = "mismatch" }
#     it { should_not be_valid }
#   end
#
#   # パスワード認証 authenticate
#   describe "returen value of authenticate method" do
#     before { @user.save }
#     let(:found_user) { User.find_by(email: @user.email) }
#
#     context "with valid password" do
#       it { should eq found_user.authenticate(@user.password) }
#     end
#     context "with invalid password" do
#       let(:incorrect) { found_user.authenticate("invalid") }
#       it { should_not eq incorrect }
#       it { expect(incorrect).to be_falsey }
#     end
#   end
#
#   # バグその２対応：異なる種類のブラウザでのログアウト問題
#
#   # モデル側の authenticated?メソッド を 一般化する前
#
#   # # authenticated?メソッド 記憶ダイジェスト の nilガード
#   # describe "authenticated? with nil remember_digest" do
#   #   # 引数の remember_token には 適当な値をセット
#   #   let(:value) { @user.authenticated?("foo") }
#   #   it { expect(value).to be_falsey }
#   # end
#
#   # モデル側の authenticated?メソッド が 一般化された後
#
#   describe "authenticated? with nil remember_digest" do
#     let(:value) { @user.authenticated?(:remember, "foo") }
#     it { expect(value).to be_falsey }
#   end
#
#   # describe "authenticated? with nil activation_digest" do
#   #   let(:value) { @user.authenticated?(:activation, "foo") }
#   #   it { expect(value).to be_falsey }
#   # end
#
# end









# require 'rails_helper'
#
# RSpec.describe User, type: :model do
#
#   before do
#     @user = User.new(name: "Example User",
#                      email: "user@example.com",
#                      password: "foobar",
#                      password_confirmation: "foobar")
#   end
#   subject { @user }
#
#   it { should respond_to(:name) }
#   it { should respond_to(:email) }
#   it { should respond_to(:password_digest) }
#   it { should respond_to(:password) }
#   it { should respond_to(:password_confirmation) }
#   it { should respond_to(:authenticate) }
#   it { should respond_to(:remember_digest) }
#   it { should respond_to(:admin) }
#
#   it { should be_valid }
#   it { should_not be_admin }
#
#   # :name
#
#   describe "when name is not present" do
#     before { @user.name = "   " }
#     it { should_not be_valid }
#   end
#
#   describe "when name is too long" do
#     before { @user.name = "a" * 51 }
#     it { should_not be_valid }
#   end
#
#   # :email
#
#   describe "when email is not present" do
#     before { @user.email = "   " }
#     it { should_not be_valid }
#   end
#
#   describe "when email is too long" do
#     before { @user.email = "a" * 255 + "@example.com" }
#     it { should_not be_valid }
#   end
#
#   describe "when email format is invalid" do
#     it "should be invalid" do
#       addresses = %w[user@foo,com user_at_foo.org example.user@foo.
#                        foo@bar_baz.com foo@bar+baz.com]
#       addresses.each do |invalid_email|
#         @user.email = invalid_email
#         expect(@user).not_to be_valid
#       end
#     end
#   end
#
#   describe "when email format is valid" do
#     it "should be valid" do
#       addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
#       addresses.each do |valid_email|
#         @user.email = valid_email
#         expect(@user).to be_valid
#       end
#     end
#   end
#
#   describe "when email address is already taken" do
#     before do
#       same_email_user = @user.dup
#       same_email_user.email = @user.email.upcase
#       same_email_user.save
#     end
#     it { should_not be_valid }
#   end
#
#   describe "when email address is mixed-case" do
#     let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
#
#     it "should be saved as lower-case" do
#       @user.email = mixed_case_email
#       @user.save
#       expect(@user.reload.email).to eq mixed_case_email.downcase
#     end
#   end
#
#   # :password
#
#   describe "when password is not present" do
#     before { @user.password = @user.password_confirmation =  "  " }
#     it { should_not be_valid }
#   end
#
#   describe "when password is too short" do
#     before { @user.password = @user.password_confirmation = "a" * 5 }
#     it { should_not be_valid }
#   end
#
#   describe "when password doesn't match confirmation" do
#     before { @user.password_confirmation = "mismatch" }
#     it { should_not be_valid }
#   end
#
#   # :authenticate
#
#   describe "returen value of authenticate method" do
#     before { @user.save }
#     let(:found_user) { User.find_by(email: @user.email) }
#
#     context "with valid password" do
#       it { should eq found_user.authenticate(@user.password) }
#     end
#     context "with invalid password" do
#       let(:user_invalid_pwd) { found_user.authenticate("invalid") }
#
#       it { should_not eq user_invalid_pwd }
#       it { expect(user_invalid_pwd).to be_falsey }
#     end
#   end
#
#   # ダイジェストが存在しない場合のauthenticated?のテスト
#   describe "authenticated? with nil digest" do
#     let(:value) { @user.authenticated?("") }
#     it { expect(value).to be_falsey }
#   end
#
#   # admin
#   describe "with admin attribute set to 'true'" do
#     before do
#       @user.save!
#       @user.toggle!(:admin)
#     end
#     it { should be_admin }
#   end
# end
