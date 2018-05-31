
要件、テスト項目を整理する
この章で使った文法




# chap06
要件、テスト項目を整理する

属性、メソッド
  :name, :email
  :password, :password_confirmation
  :password_digest
  :authenticate

バリデーション
  存在性
    :name, :email,
  文字数
  フォーマット
  一意性（大文字でも小文字でも同じとみなす）

:password_confirmation
  password と一致しない場合は invalidオブジェクトになること

パスワード認証(:authenticateメソッド)
  ユーザーを返すこと
  間違ったパスワードの場合は false を返すこと


# chap06
この章で使った文法


# 属性、メソッド
# :name
# :email
# :password_digest
# :password
# :password_confirmation
# authenticateメソッド
#
# バリデーション
# 名前
# "when name is not present"
# "when name is too long"
#
# メールアドレス
# "when email is not present"
# "when email is too long"
# "when email format is invalid"
# "when email format is valid"
# "when email address is already taken"
# "when email address is mixed case"
#
# パスワード
# "when password is not present"
# "when password doesn't match confirmation"
# "when password is too short"
#
# メソッドの返り値
# # authenticated?
# "returen value of authenticate method"


# Userオブジェクト
# when name is not present,  should not be valid
# when name is too long,     should not be valid
# when email is not present,  should not be valid
# when email is too long,        should not be valid
# when email format is invalid,  should be invalid
# when email format is valid,    should be valid
# when email address is already taken,  should not be valid
# when email address is mixed-case,  should be saved as lower-case
# when password is not present,  should not be valid
# when password is too short,  should not be valid
# when password is not-match confirmation,  should not be valid
# returen value of authenticate method
#   with valid password の場合、ユーザーを返すこと
#   with invalid password  の場合、false を返すこと
