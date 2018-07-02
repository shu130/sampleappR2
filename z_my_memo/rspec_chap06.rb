６章〜１０章まとめ

テスト項目、要件をまとめ

対象
app/models/user.rb
spec/models/user_spec.rb

属性、メソッドを持っているか？
  :name, :email
  :password, :password_confirmation
  :password_digest
  :authenticate

バリデーションは機能しているか？
  存在性 presence
    :name, :email, :password

  文字数
    :name は maximum 51 文字
    :email は minimum 6 文字

  :email のフォーマット
    正規表現を使って

  一意性 unique（大文字でも小文字でも同じとみなす）
    :email
    :password

:password_confirmation は？
  password と一致しない場合は invalidオブジェクトになること

パスワード認証(authenticateメソッド) は 機能しているか？
  ユーザーを返すこと
  間違ったパスワードの場合は false を返すこと
