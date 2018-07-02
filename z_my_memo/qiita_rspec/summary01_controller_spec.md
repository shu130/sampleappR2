# RailsチュートリアルテストをRSpecでやってみる [単体テスト][コントローラ]
<!--
### Sessionsコントローラ 単体テスト（８章）
### Userコントローラ 単体テスト（１０章）
対象
users_controller_spec.rb
sessions_controller_spec.rb
 -->

### 対象

コントローラ  | スペックファイル名  | テキスト内で該当する章
--|---|--
Sessionsコントローラ  | sessions_controller_spec.rb  | ８章
Usersコントローラ  | users_controller_spec.rb  | １０章

<!-- Micropostsコントローラ  | sessions_controller_spec.rb  | １３章 -->

<!--
テスト方法  | 対象ファイル
--|---|
Minitest  | test/controllers/users_controller_test.rb
RSpec  | users_controller_spec.rb
 -->

### なるべくDRYにしてみる
頻繁に使うテスト、使い回したいテストを整理する
<!-- shared_examples_for でまとめる
shared_context でまとめる -->
<!--
shared_examples_for "foo" で先に定義し、it_behave_like "foo" で呼び出す
shared_context で先に定義し、include_context で呼び出す
 -->

使い回したいテストの定義  | 呼び出しかた | 格納先とファイル名
--|---|--
shared_examples_for "foo"  |  it_behave_like "foo" | spec/support/shared_examples.rb
shared_context "bar"  |  include_context "bar" | spec/support/shared_context.rb

### 正常系／異常系のパターン まとめ

  <!-- ログインの有or無 and 情報が有効or無効

Usersコントローラ | Micropostsコントローラ
--|--
update | create -->

`sessions#create`
```ruby
# 情報が 有効or無効
describe "xxxx"
  context "with valid infomation"
  context "with invalid infomation"
```
`users#index`
```ruby
  describe "xxxx"
    context "when logged-in"
    context "when not logged-in"
```
`users#create/update` `micropost#create`
```ruby
# ログインの有or無 and 情報が有効or無効
  describe "xxxx"
    context "when logged-in"
      # normal
      context "with valid attributes"
      # abnomal
      context "with invalid attributes"
    context "when not logged-in"
```
`users#edit` `microposts#destroy`
```ruby
# ログインの有or無 and 認証(authorization)
  describe "xxxx"
    context "when logged-in"
      # normal
      context "as rigtht-user"
      # abnomal
      context "as wrong-user"
    context "when not logged-in"
```
`users#destroy`
```ruby
# ログインの有or無 and 認証(admin)
  describe "xxxx"
    context "when logged-in"
      # normal
      context "as non-admin-user"
      # abnormal
      context "as admin-user"
    context "when not logged-in"
```

### 項目まとめ shared_examples

```ruby
インスタンス変数の割り当て(assigns)が正しいこと
httpリクエストが成功すること
viewの読み込みが正しいこと(template)
flashメッセージの表示が正しいこと
データが作成されること(increment:1)
データが更新されること(increment:0)
データが削除されること(increment:-1)
データ数に変化がないこと(increment:0)
```

<!--
複数オブジェクトを表示（index）できること
特定オブジェクトを表示（show）できること
新規オブジェクトを登録（create）できること
既存オブジェクトの更新（update）ができること
既存オブジェクトの削除（delete）ができること
 -->
<!--
個別
（Topsコントローラ）
ページタイトルが正しいこと
（Usersコントローラ）
ユーザの削除（delete）は管理者ユーザはできるが、一般ユーザはできないこと
（Sessionsコントローラ）
ログインが成功し、且つredirect先が正しいこと
 -->

##### メモ: assignsメソッド
インスタンス変数への割り当て(assigns)が正しいこと

assignsメソッド（意味）  |  Usersコントローラ
--|--
@users に複数ユーザーを割り当てる  |  index
@user に新規ユーザーを割り当てる  |  create
@userにリクエストされたユーザーを割り当てる  |  show, edit, update, destroy
<!--
（Usersコントローラの場合）
  @users に複数ユーザーを割り当てる             # index
  @user に新規ユーザーを割り当てる              # new, create
  @user にリクエストされたユーザーを割り当てる  # show, edit, update, destroy
 -->

### 項目まとめ shared_context

```ruby
ログイン画面に遷移し、メッセージが出力される
他人のユーザ情報は 表示（edit）できないこと
他人のユーザ情報は 更新（update）できないこと
admin属性への 更新（update）はできないこと
```

### アウトライン users_controller_spec.rb
```ruby
#index
  正常系
    複数ユーザの表示 OK
  異常系
    ログイン画面に遷移し、メッセージが出力される
#show
  特定ユーザの表示 OK
#new
  サインアップ画面の表示
#create
  正常系
    新規ユーザを登録（create） OK
    データ数が増加すること(increment:1)
  異常系
    データ数に変化がないこと(increment:0)
#edit
  正常系
    自分のユーザ情報の 表示 OK
    他人のユーザ情報は 表示（show）NG
  異常系
    ログイン画面に遷移し、メッセージが出力される
#update
  正常系
    正常系 valid_params
      自分のユーザ情報の 更新（update） OK
      データ数に変化がないこと(increment:0)
    異常系 invalid_params
      データ数に変化がないこと(increment:0)
  異常系
    ログイン画面に遷移し、メッセージが出力される
    他人のユーザ情報は 更新（update）NG
    admin属性への 更新（update）はできないこと

#destroy
  正常系
    一般ユーザは ユーザ情報 削除（delete）OK
    管理者ユーザは ユーザ情報 削除（delete）OK
    データ数が減少すること(increment:-1)
  異常系
    データ数に変化がないこと(increment:0)
```

### なるべくDRYにしてみる
spec側でブロックをオブジェクト化(`Proc.new { }`)して `subject { }` に定義
shared_examples側で、`subject.call` して呼び出す

spec側
```ruby
users_controller_spec.rb

  describe "GET #show" do
    # リクエストのブロックをオブジェクト化して subject に定義
    subject { Proc.new { get :show, params: { id: user.id } } }
    it_behaves_like "assigned @value is equal value", :user
    it_behaves_like "returns http status", :success
  end
```
shared_examples側
```ruby
shared_examples.rb
  # assigns
  shared_examples_for "assigned @value is equal value" do |value|
    # object.call で subject を呼び出したあとに exampleを評価させる
    it { subject.call; expect(value).to eq value }
  end
  # http status
  shared_examples_for "returns http status" do |status|
    it { subject.call; expect(response).to have_http_status(status) }
  end
```

### 使用する変数の整理
  変数はまとめて先頭に定義してしまう

変数（インスタンス化） | 使い方（アクション）
--|--
user  | 特定のユーザの表示（show）
other_users  | 複数ユーザの表示（index）
other_user  | 他人の ユーザ情報 編集（edit）NG、更新（update）NG
admin  | 管理者ユーザは ユーザ情報 削除（delete）OK
valid_params  | ユーザ情報 登録（create）OK

変数（パラメータハッシュ） | 使い方（アクション）
--|--
valid_params  | ユーザ情報 登録（create）OK
invalid_params  | ユーザ情報 登録（create）NG
update_params_1  | 自分の ユーザ情報 更新（update）OK
update_params_2  | 他人の ユーザ情報 更新（update）NG
admin_params  | admin属性への 更新（update）NG

```ruby
# spec側
# users_controller_spec.rb
require 'rails_helper'
RSpec.describe UsersController, type: :controller do

  # let! で DBに保存し、レコードが７つある状態にしておく
  let!(:other_users) { create_list(:other_user, 5) }
  let!(:other_user) { create(:other_user) }
  let!(:admin) { create(:admin) }
  # let で 変数が呼ばれたタイミングで DB保存されるようにしておく
  let(:user) { create(:user) }

  # 属性をハッシュ化して呼ばれた時に使う
  let(:valid_params) { attributes_for(:user) }
  let(:invalid_params) { attributes_for(:user, name: nil) }
  let(:update_params_1) { attributes_for(:user, name: "New name") }
  let(:update_params_2) { attributes_for(:other_user, name: "New name") }
  let(:admin_params) { attributes_for(:user, admin: true) }

end
```
### サンプルユーザの作成
  ファクトリ側は、３種類の用意しておく
```ruby
ファクトリ側
spec/factories/sample_users.rb

  factory :user, class: User do
    name     "Example user"
    email    "user@example.com"
    password              "foobar"
    password_confirmation "foobar"
    admin false
  end

  factory :other_user, class: User do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password              "password"
    password_confirmation "password"
    admin false
  end

  factory :admin, class: User do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
    admin true
  end

```

### 作成 shared_examples
```ruby
spec/support/shared_examples.rb
                      # shared_examples
  # assigns
  shared_examples_for "assigned @value is equal value" do |value|
    it { subject.call; expect(value).to eq value }
  end
  # http status
  shared_examples_for "returns http status" do |status|
    it { subject.call; expect(response).to have_http_status(status) }
  end
  # render template
  shared_examples_for "render template" do |template|
    it { subject.call; expect(response).to render_template template }
  end
  # redirect to url
  shared_examples_for "redirect to url" do |url|
    it { subject.call; expect(response).to redirect_to url }
  end

  # フラッシュメッセージ

  # flash[:success]
  shared_examples_for "have success messages" do |msg|
    it { subject.call; expect(flash[:success]).to eq msg }
  end
  # flash[:danger]
  shared_examples_for "have error messages" do |msg|
    it { subject.call; expect(flash[:danger]).to eq msg }
  end

  # データ数の増減（モデルに関するもの）

  # create
  shared_examples_for "create data (increment:1)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(1) } # or
    # it { expect{ subject.call }.to change{ model.count }.by(1) }
  end
  # update
  shared_examples_for "update data (increment:0)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(0) }
  end
  # destroy
  shared_examples_for "delete data (increment:-1)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(-1) }
  end
  # データ数に変化なし
  shared_examples_for "not change data (increment:0)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(0) }
  end
```

### 作成 shared_context
```ruby
spec/support/shared_context.rb

                      # shared_context
  # abnomal
  # ログイン画面に遷移し、ログインメッセージが出力される
  shared_context "redirect_to login_url with error messages" do
    it_behaves_like "redirect to url", "/login"
    it_behaves_like "have error messages", "Please log in"
  end

  # in users_controller_spec
  # show
  # 他人のユーザ情報は 表示（show）できないこと
  shared_context "not allow show other-user's-profile" do
    subject { Proc.new { get :edit, params: { id: other_user.id } } }
    it_behaves_like "redirect to url", "/"
    it_behaves_like "returns http status", :redirect
  end
  # update
  # 他人のユーザ情報は 更新（update）できないこと
  shared_context "update other-user's-profile" do
    subject { Proc.new { patch :update, params: { id: other_user.id, user: update_params_2 } } }
    it_behaves_like "returns http status", :redirect
    it_behaves_like "not change data (increment:0)", User
  end
  # admin属性を操作できないこと
  shared_context "change admin-attribute via the web" do
    subject { Proc.new { patch :update, params: { id: user.id, user: admin_params } } }
    it_behaves_like "not change data (increment:0)", User
    it "admin-attribute should be false" do
      subject.call; expect(user.admin).to eq false
    end
  end
```

### 完成 users_controller_spec
```ruby
require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  # let! で DBに保存し、レコードが７つある状態にしておく
  let!(:other_users) { create_list(:other_user, 5) }
  let!(:other_user) { create(:other_user) }
  let!(:admin) { create(:admin) }
  # let で 変数が呼ばれた時に DB保存されるようにしておく(users/8)
  let(:user) { create(:user) }

  # 属性をハッシュ化して呼ばれた時に使う
  let(:valid_params) { attributes_for(:user) }
  let(:invalid_params) { attributes_for(:user, name: nil) }
  let(:update_params_1) { attributes_for(:user, name: "New name") }
  let(:update_params_2) { attributes_for(:other_user, name: "New name") }
  let(:admin_params) { attributes_for(:user, admin: true) }

  describe "GET #index" do
    subject { Proc.new { get :index } }
    # normal
    context "when logged-in" do
      before(:each) { log_in_as user }
      it_behaves_like "returns http status", :success
      it_behaves_like "assigned @value is equal value", :other_users
      it_behaves_like "render template", :index
    end
    # abnormal
    context "when not logged-in" do
      include_context "redirect_to login_url with error messages"
    end
  end

  describe "GET #show" do
    subject { Proc.new { get :show, params: { id: user.id } } }
    it_behaves_like "assigned @value is equal value", :user
    it_behaves_like "returns http status", :success
    it_behaves_like "render template", :show
  end

  describe "GET #new" do
    subject { Proc.new { get :new } }
    it_behaves_like "returns http status", :success
    it_behaves_like "render template", :new
  end

  describe "POST #create" do
    # nomal
    context "with valid attributes" do
      subject { Proc.new { post :create, params: { user: valid_params } } }
      it_behaves_like "assigned @value is equal value", :user
      it_behaves_like "create data (increment:1)", User
      it_behaves_like "returns http status", :redirect
      it_behaves_like "redirect to url", "/users/8"
      it_behaves_like "have success messages", "Welcome to the Sample App!"
    end
    # abnomal
    context "with invalid attributes" do
      subject { Proc.new { post :create, params: { user: invalid_params } } }
      it_behaves_like "not change data (increment:0)", User
      it_behaves_like "render template", :new
    end
  end

  describe "GET #edit" do
    subject { Proc.new { get :edit, params: { id: user.id } } }
    # normal
    context "when logged-in" do
      before(:each) { log_in_as user }
      # normal
      context "as rigtht_user" do
        it_behaves_like "returns http status", :success
        it_behaves_like "render template", :edit
        it_behaves_like "assigned @value is equal value", :user
      end
      # abnormal
      context "as wrong_user" do
        # 他人のユーザ情報は 表示（edit）できないこと
        include_context "not allow edit other-user's-profile"
      end
    end
    # abnormal
    context "when not logged-in" do
      include_context "redirect_to login_url with error messages"
    end
  end

  describe "PATCH #update" do
    # normal
    context "when logged-in" do
      before(:each) { log_in_as user }
      # normal
      context "with valid attributes" do
        subject { Proc.new { patch :update, params: { id: user.id, user: update_params_1 } } }
        it_behaves_like "assigned @value is equal value", :user
        it_behaves_like "update data (increment:0)", User
        it_behaves_like "returns http status", :redirect
        it_behaves_like "redirect to url", "/users/8"
        it_behaves_like "have success messages", "Profile updated"
      end
      # abnomal
      context "with invalid attributes" do
        subject { Proc.new { patch :update, params: { id: user.id, user: invalid_params } } }
        it_behaves_like "not change data (increment:0)", User
        it_behaves_like "render template", :edit
      end
    end
    # abnormal
    context "when not logged-in" do
      # abnormal
      context "as wrong-user" do
        include_context "redirect_to login_url with error messages"
        # 他人のユーザ情報は更新（update）できないこと
        include_context "not allow update other-user's-profile"
      context "as admin-user" do
        # admin属性を操作できないこと
        include_context "not allow change admin-attribute via the web"
      end
      end
    end
  end

  describe "DELETE #destroy" do
    subject { Proc.new { delete :destroy, params: { id: other_user.id } } }
    # normal
    context "when logged-in" do
      context "as non-admin-user" do
        before(:each) { log_in_as user }
        it_behaves_like "returns http status", :redirect
        it_behaves_like "redirect to url","/"
        it_behaves_like "assigned @value is equal value", :other_user
        # it_behaves_like "delete data (increment:-1)", User
        it_behaves_like "not change data (increment:0)", User
      end
      context "as admin-user" do
        before(:each) { log_in_as admin }
        # it_behaves_like "returns http status", :success
        it_behaves_like "assigned @value is equal value", :admin
        it_behaves_like "delete data (increment:-1)", User
        it_behaves_like "returns http status", :redirect
        it_behaves_like "redirect to url","/users"
        it_behaves_like "have success messages", "User deleted"
      end
    end
    # abnormal
    context "when not logged-in" do
      include_context "redirect_to login_url with error messages"
      it_behaves_like "not change data (increment:0)", User
    end
  end
end
```

<!-- メモ
ファクトリ作成に関して

### DBへの保存状態を変えて生成する(build/build_stubbed/create/attributes_for)

生成するメソッドによって、DBへの保存状態や取得対象を変えることができる。

メソッド            | 戻り値                | DB保存    | DB保存(アソシエーション)  | ID
---                 | ---                   | ---       | ---                       | ---
`build()`           | モデルインスタンス    | x         | o                         | nil
`build_stubbed()`   | モデルインスタンス    | x         | x                         | 適当な値
`create()`          | モデルインスタンス    | o         | o                         | DB保存された値
`attributes_for()`  | パラメータハッシュ    | x         | x                         | なし


```ruby:test
# DB保存しない状態で生成(アソシエーションは保存する)
alice = build(:alice)
#=> #<User id: nil, name: "Alice", admin: true, created_at: nil, updated_at: nil>

# DB保存しない状態で生成(アソシエーションも保存しない, IDには適当な値が入る)
alice = build_stubbed(:alice)
#=> #<User id: 1001, name: "Alice", admin: true, created_at: nil, updated_at: nil>

# DB保存された状態で生成
alice = create(:alice)
#=> #<User id: 1, name: "Alice", admin: true, created_at: "2017-06-06 17:42:09", updated_at: "2017-06-06 17:42:09">

# 属性のハッシュを生成
alice = attributes_for(:alice)
#=> {:name=>"Alice", :admin=>true}
``` -->
