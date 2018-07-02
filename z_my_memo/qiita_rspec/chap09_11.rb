９章、１１章のテスト項目をまとめてみます。


Userモデルの authenticated?メソッドのテストです。

新しく追加した属性が応答するか？
  :remember_digest
  :activation_digest

authenticated?メソッド（一般化前）
  記憶ダイジェスト が nil の場合、false を返すこと

authenticated?メソッド（一般化後）
  記憶ダイジェスト が nil の場合、false を返すこと
  有効化ダイジェスト が nil の場合、false を返すこと


Userモデル
  記憶トークンが、記憶ダイジェストと一致するか？
  # authenticated?メソッド（一般化前）
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end


新しく追加した属性が応答するか？
  :remember_digest
  :activation_digest

rspec
spec/models/user_spec.rb

  it { should respond_to(:remember_digest) }
  it { should respond_to(:activation_digest) }

minitest
test/models/user_test.rb

  assert_respond_to(@user, :remember_digest)
  assert_respond_to(@user, :activation_digest)


authenticated?メソッド（一般化前）
  記憶ダイジェスト が nil の場合、false を返すこと

rspec
spec/models/user_spec.rb

  # authenticated?メソッド 記憶ダイジェスト の nilガード
  describe "authenticated? with nil digest" do
    let(:value) { @user.authenticated?("") }
    it { expect(value).to be_falsey }
  end

minitest
test/models/user_test.rb

  # authenticated?メソッド 記憶ダイジェスト の nilガード
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end


Userモデル
  （記憶/有効化）トークンが、（記憶/有効化）ダイジェストと一致するか？
  # authenticated?メソッド（一般化後）
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

authenticated?メソッドの引数が２つになったので、
sessions_helper 内で使われている authenticated?メソッド部分を変更
app/helpers/sessions_helper.rb

  # ...

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      # if user && user.authenticated?(cookies[:remember_token])
      # ↓変更
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end


authenticated?メソッド（一般化後）
  記憶ダイジェスト が nil の場合、false を返すこと
  有効化ダイジェスト が nil の場合、false を返すこと

rspec
spec/models/user_spec.rb

  # authenticated?メソッド (記憶/有効化)ダイジェスト の nilガード
  describe "authenticated? with nil digest" do
    let(:value_rem) { @user.authenticated?(:remember, "") }
    let(:value_act) { @user.authenticated?(:activation, "") }
    it { expect(value_rem).to be_falsey }
    it { expect(value_act).to be_falsey }
  end

minitest
test/models/user_test.rb

  # authenticated?メソッド (記憶/有効化)ダイジェスト の nilガード
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
    assert_not @user.authenticated?(:activation, "")
  end
