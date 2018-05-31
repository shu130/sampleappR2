
# chap06
# テストの項目、要件


# chap06
# 使う文法
@user.email = "   "
@user.name = "a" * 51
@user.dup
assert @user.valid?
assert_not @user.valid?
@user.email.inspect


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
