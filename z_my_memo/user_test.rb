
# chap11
リスト 11.29: Userテスト内の抽象化したauthenticated?メソッド

# chap10
# なし

# chap09
リスト 9.17: ダイジェストが存在しない場合のauthenticated?のテスト

# :name
  test "name should be present (non-blank)"
  test "name should not be too long"
# :email
  test "email should be present"
  test "email should not be too long"
  test "email validation should accept valid addresses"
  test "email validation should reject invalid addresses"
  test "email addresses should be unique"
  test "email addresses should be saved as lower-case"
# :password
  test "password should be present (non-blank)"
  test "password should have a minimum length"
# authenticated? method
  test "authenticated? should return false for a user with nil digest"


# chap07, chap08
# なし


# chap06
# :name
  test "name should be present (non-blank)"
  test "name should not be too long"
# :email
  test "email should be present"
  test "email should not be too long"
  test "email validation should accept valid addresses"
  test "email validation should reject invalid addresses"
  test "email addresses should be unique"
  test "email addresses should be saved as lower-case"
# :password
  test "password should be present (non-blank)"
  test "password should have a minimum length"


# chap06
# list
リスト 6.4: デフォルトのUserテスト (モックのみ)
リスト 6.5: 有効なUserかどうかをテスト
リスト 6.7: name属性にバリデーションに対するテスト
リスト 6.11: email属性の検証に対するテスト
リスト 6.14: nameの長さの検証に対するテスト
リスト 6.18: 有効なメールフォーマットをテスト
リスト 6.19: メールフォーマットの検証に対するテスト
リスト 6.24: 重複するメールアドレス拒否のテスト
リスト 6.26: 大文字小文字を区別しない、一意性のテスト
リスト 6.33: リスト 6.32のメールアドレスの小文字化に対するテスト
リスト 6.39: パスワードとパスワード確認を追加する
リスト 6.41: パスワードの最小文字数をテスト



# chap06_bkup
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
    assert_respond_to(@user, :authenticate)
    assert_respond_to(@user, :password_digest)
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
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # 文字数
  test "name should not be too long" do
    @user.name = "a" * 51
  end

  test "email should not be too long" do
    @user.email = "a" * 255 + "@exaple.com"
  end

  test "name should not be too long" do
    @user.name = "a" * 51
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
    @email.email = mixed_case_email
    @email.save
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

end




# # chap06_bkup
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
#   test "should respond some attribute or method" do
#     assert_respond_to(@user, :name)
#     assert_respond_to(@user, :email)
#     assert_respond_to(@user, :password)
#     assert_respond_to(@user, :password_digest)
#     assert_respond_to(@user, :authenticate)
#     assert_respond_to(@user, :admin)
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
#   test "authenticate should return user" do
#     @user.save
#     assert_not @user.authenticate("invalid")
#     assert @user.authenticate(@user.password)
#   end
#
# end
