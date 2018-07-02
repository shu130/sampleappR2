# タイトル
Railsチュートリアル
テストを Rspecとminitest の両方でやってみる

目的
Railsチュートリアルの内容の整理
両方のテストの書き方を覚える

Userモデル

Userモデル のテストは６章、９章、１１章に登場しています。
まず、６章のテスト項目をまとめてみます。

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
    :email は maximum 255 文字
    :password は minimum 6 文字

  :email のフォーマット
    メールアドレスとしてのフォーマットの正しさ（正規表現）

  :email の一意性 unique
    大文字でも小文字の区別がない case insensitive な unique性

beforeフィルタ
  :email が before_save で データベースに 小文字で保存されること


属性 :password_confirmation については？
  password と一致しない場合は invalidオブジェクトになること

パスワード認証については？
  authenticateメソッドが、正しいユーザーを返すこと
  間違ったパスワードの場合は false を返すこと


では、一つ一つ書いてみます。


属性、メソッドを持っているか？

rspec
spec/models/user_spec.rb
beforeブロック と subject を使ってワンライナーで記載

  # 属性、メソッドの応答
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:password_digest) }

普通の書き方
  it "should respond to 'name'" do
    expect(@user).to respond_to(:name)
  end


minitest
test/models/user_test.rb
チュートリアルには登場していないので、自分で作成

  # 属性、メソッドの応答
  test "should respond attribute or method" do
    assert_respond_to(@user, :name)
    assert_respond_to(@user, :email)
    assert_respond_to(@user, :password)
    assert_respond_to(@user, :password_confirmation)
    assert_respond_to(@user, :authenticate)
    assert_respond_to(@user, :password_digest)
  end

メモ：文法と意味
assert_respond_to( obj, symbol, [msg] )
  obj は symbol に応答する と主張する。
assert_not_respond_to( obj, symbol, [msg] )
  obj は symbol に応答しない と主張する。
（「Rails テスティングガイド」から 抜粋）




テスト
バリデーションは機能しているか？


存在性 presence
  :name, :email, :password

rspec
spec/models/user_spec.rb

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


minitest
test/models/user_test.rb

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



文字数
  :name は maximum 51 文字
  :email は maximum 255 文字
  :password は minimum 6 文字

rspec
spec/models/user_spec.rb

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
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

実行結果の見え方
    when name is too long
    should not be valid


minitest
test/models/user_test.rb

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



:email のフォーマット
  メールアドレスとしてのフォーマットの正しさ（正規表現）

rspec
spec/models/user_spec.rb

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

minitest
test/models/user_test.rb

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



:email 一意性 unique
  大文字でも小文字の区別がない case insensitive な unique性

rspec
spec/models/user_spec.rb

  # email 一意性 unique
  # その１：チュートリアルでの書き方
  describe "when email address is already taken" do
    before do
      dup_user = @user.dup
      dup_user.email = @user.email.upcase
      dup_user.save
    end
    it { should_not be_valid }
  end
  # その２： これでもOK だった
  describe "when email address is already taken" do
    let(:dup_user) { dup_user = @user.dup }
    before do
      @user.save
      dup_user.email = @user.email.upcase
    end
    it do
      expect(dup_user).not_to be_valid
    end
  end

minitest
test/models/user_test.rb

  # email 一意性 unique
  test "email address should be unique" do
    dup_user = @user.dup
    dup_user.email = @user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end



beforeフィルタ
  :email が before_save で データベースに 小文字で保存されること

rspec
spec/models/user_spec.rb

  # email の beforeフィルタ
  describe "when email address is mixed-case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
    it "should be saved as lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end


minitest
test/models/user_test.rb

  # email の beforeフィルタ
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

メモ：文法と意味
assert_equal( expected, actual, [msg] )
  expected == actual は true である と主張する。
assert_not_equal( expected, actual, [msg] )
  expected != actual は true である と主張する。
（「Rails テスティングガイド」から 抜粋）



属性 :password_confirmation については？
  password と一致しない場合は invalidオブジェクトになること

rspec
spec/models/user_spec.rb

  # :password_confirmation
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end


minitest
test/models/user_test.rb

  # :password_confirmation
  test "password should match password_confirmation" do
    @user.password_confirmation = "mismatch"
    assert_not @user.valid?
  end


パスワード認証については？
  authenticateメソッドが、正しいユーザーを返すこと
  間違ったパスワードの場合は false を返すこと

rspec
spec/models/user_spec.rb

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


minitest
test/models/user_test.rb

チュートリアルには登場していないので、自分で作成

  # パスワード認証 authenticate
  test "authenticate should return correct user" do
    @user.save
    found_user = User.find_by(email: @user.email)
    assert_equal found_user, @user.authenticate(@user.password)
    assert_not_equal found_user, @user.authenticate("invalid")
  end



６章は終わり
