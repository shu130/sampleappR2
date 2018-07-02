# chap11
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User",
                     email: "user@example.com",
                     password: "foobar",
                     password_confirmation: "foobar")
  end

  # オブジェクトの有効性
  test "should be valid" do
    assert @user.valid?
  end

  # 属性、メソッドの応答
  test "should respond attribute or method" do
    assert_respond_to(@user, :name)
    assert_respond_to(@user, :email)
    assert_respond_to(@user, :password)
    assert_respond_to(@user, :password_confirmation)
    assert_respond_to(@user, :authenticate)
    assert_respond_to(@user, :password_digest)
    assert_respond_to(@user, :remember_digest)
    assert_respond_to(@user, :activation_digest)
  end

  # 存在性 presence
  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "password should be present (non-blank)" do
    @user.password = @user.password_confirmation = "   "
    assert_not @user.valid?
  end

  # 文字数
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 255 + "@exaple.com"
    assert_not @user.valid?
  end

  test "password should not be too short" do
    @user.name = "a" * 5
    assert_not @user.valid?
  end

  # email のフォーマット
  test "email validation should reject invalid addresses" do
    invalid_addr = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addr.each do |addr|
      @user.email = addr
      assert_not @user.valid?, "#{addr.inspect} should be invalid"
    end
  end

  test "email validation should accept valid addresses" do
    valid_addr = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addr.each do |addr|
      @user.email = addr
      assert @user.valid?, "#{addr.inspect} should be invalid"
    end
  end

  # email 一意性 unique
  test "email address should be unique" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end

  # email の beforeフィルタ
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # :password_confirmation
  test "password should match password_confirmation" do
    @user.password_confirmation = "mismatch"
    assert_not @user.valid?
  end

  # パスワード認証 authenticate
  test "authenticate should return correct user" do
    @user.save
    found_user = User.find_by(email: @user.email)
    assert_equal found_user, @user.authenticate(@user.password)
    assert_not_equal found_user, @user.authenticate("invalid")
  end

  # # authenticated?メソッド 記憶ダイジェスト の nilガード
  # test "authenticated? should return false for a user with nil digest" do
  #   assert_not @user.authenticated?('')
  # end

  # authenticated?メソッド (記憶/有効化)ダイジェスト の nilガード
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
    assert_not @user.authenticated?(:activation, "")
  end

end




# # chap06
# require 'test_helper'
#
# class UserTest < ActiveSupport::TestCase
#
#   def setup
#     @user = User.new(name: "Example User",
#                      email: "user@example.com",
#                      password: "foobar",
#                      password_confirmation: "foobar")
#   end
#
#   # オブジェクトの有効性
#   test "should be valid" do
#     assert @user.valid?
#   end
#
#   # 属性、メソッドの応答
#   test "should respond attribute or method" do
#     assert_respond_to(@user, :name)
#     assert_respond_to(@user, :email)
#     assert_respond_to(@user, :password)
#     assert_respond_to(@user, :authenticate)
#     assert_respond_to(@user, :password_digest)
#   end
#
#   # 存在性 presence
#   test "name should be present" do
#     @user.name = "   "
#     assert_not @user.valid?
#   end
#
#   test "email should be present" do
#     @user.email = "   "
#     assert_not @user.valid?
#   end
#
#   test "password should be present (non-blank)" do
#     @user.password = @user.password_confirmation = " " * 6
#     assert_not @user.valid?
#   end
#
#   # 文字数
#   test "name should not be too long" do
#     @user.name = "a" * 51
#   end
#
#   test "email should not be too long" do
#     @user.email = "a" * 255 + "@exaple.com"
#   end
#
#   test "name should not be too long" do
#     @user.name = "a" * 51
#   end
#
#   # email のフォーマット
#   test "email validation should reject invalid addresses" do
#     invalid_addr = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
#     invalid_addr.each do |addr|
#       @user.email = addr
#       assert_not @user.valid?, "#{addr.inspect} should be invalid"
#     end
#   end
#
#   test "email validation should accept valid addresses" do
#     valid_addr = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
#     valid_addr.each do |addr|
#       @user.email = addr
#       assert @user.valid?, "#{addr.inspect} should be invalid"
#     end
#   end
#
#   # email 一意性 unique
#   test "email address should be unique" do
#     dup_user = @user.dup
#     dup_user.email = @user.email.upcase
#     @user.save
#     assert_not dup_user.valid?
#   end
#
#   # email の beforeフィルタ
#   test "email addresses should be saved as lower-case" do
#     mixed_case_email = "Foo@ExAMPle.CoM"
#     @email.email = mixed_case_email
#     @email.save
#     assert_equal mixed_case_email.downcase, @user.reload.email
#   end
#
#   # :password_confirmation
#   test "password should match password_confirmation" do
#     @user.password_confirmation = "mismatch"
#     assert_not @user.valid?
#   end
#
#   # パスワード認証 authenticate
#   test "authenticate should return correct user" do
#     @user.save
#     found_user = User.find_by(email: @user.email)
#     assert_equal found_user, @user.authenticate(@user.password)
#     assert_not_equal found_user, @user.authenticate("invalid")
#   end
#
# end
#
#










# # chap_all
# require 'test_helper'
#
# class UserTest < ActiveSupport::TestCase
#
#   def setup
#     @user = User.new(name: "Example User",
#                      email: "user@example.com",
#                      password: "foobar",
#                      password_confirmation: "foobar")
#   end
#
#   test "should respond some attribute or method" do
#     assert_respond_to(@user, :name)
#     assert_respond_to(@user, :email)
#     assert_respond_to(@user, :password)
#     assert_respond_to(@user, :password_digest)
#     assert_respond_to(@user, :authenticate)
#     assert_respond_to(@user, :admin)
#   end
#
#   # @user
#   test "should be valid" do
#     assert @user.valid?
#   end
#
#   # name
#   test "name should be present" do
#     @user.name = "   "
#     assert_not @user.valid?
#   end
#
#   test "name should not be too long" do
#     @user.name = "a" * 51
#     assert_not @user.valid?
#   end
#
#   # email
#   test "email should be present" do
#     @user.email = "   "
#     assert_not @user.valid?
#   end
#
#   test "email should not be too long" do
#     @user.email = "a" * 255 + "@example.com"
#     assert_not @user.valid?
#   end
#
#   test "email validation should accept valid addresses" do
#     valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
#                          first.last@foo.jp alice+bob@baz.cn]
#     valid_addresses.each do |valid_email|
#       @user.email = valid_email
#       assert @user.valid?, "#{valid_email.inspect} should be valid"
#     end
#   end
#
#   test "email validation should reject invalid addresses" do
#     invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
#     invalid_addresses.each do |invalid_email|
#       @user.email = invalid_email
#       assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
#     end
#   end
#
#   test "email addresses should be unique" do
#     duplicate_user = @user.dup
#     duplicate_user.email = @user.email.upcase
#     @user.save
#     assert_not duplicate_user.valid?
#   end
#
#   test "email addresses should be saved as lower-case" do
#     mixed_case_email = "Foo@ExAMPle.CoM"
#     @user.email = mixed_case_email
#     @user.save
#     assert_equal mixed_case_email.downcase, @user.reload.email
#   end
#
#   # password
#   test "password should be present (non-blank)" do
#     @user.password = @user.password_confirmation = " " * 6
#     assert_not @user.valid?
#   end
#
#   test "password should have a minimum length" do
#     @user.password = @user.password_confirmation = "a" * 5
#     assert_not @user.valid?
#   end
#
#   test "password should match password_confirmation" do
#     @user.password_confirmation = "mismatch"
#     assert_not @user.valid?
#   end
#
#   test "authenticate should return correct user" do
#     @user.save
#     found_user = User.find_by(email: @user.email)
#     assert_equal found_user, @user.authenticate(@user.password)
#     assert_not_equal found_user, @user.authenticate("invalid")
#   end
#
#
#   # # authenticated? method
#   # test "authenticated? should return false for a user with nil digest" do
#   #   assert_not @user.authenticated?("")
#   # end
#
# end
