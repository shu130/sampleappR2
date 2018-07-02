# RailsチュートリアルテストをRSpecでやってみる [単体テスト][コントローラ]

### Userコントローラ 単体テスト（１０章）

テスト方法  | 対象ファイル
--|---|
Minitest  | test/controllers/users_controller_test.rb
RSpec  | users_controller_spec.rb

### Userコントローラ 単体テスト 項目まとめ

<!-- 1. ####  ページネーション

1. ####  ユーザの削除リンク
  adminユーザの場合 -->


```ruby
RSpec
spec/controllers/users_controller_spec.rb


# メモ
be_ok # 200
be_success # 200番台
be_successful # 200番台
be_redirect # 301, 302, 303, 307のどれか
be_forbidden # 403
be_not_found # 404
be_missing # 404

  # 頻繁に使うので一般化したいテスト
  # shared_examples_for で先に定義し、it_behave_like で呼び出す
  expect(assigns(:users)).to eq users
  expect(assigns(:user)).to eq user
  expect(response).to have_http_status(:success)
  expect(response).to render_template （テンプレート名）
  expect(response).to redirect_to （url）

  # 変数として先に定義して呼ばれた時に使う
  # DB保存
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:users) { create_list(:other_user, 5) }
  let(:other_user) { create(:other_user) }
  # 属性のハッシュ化
  let(:valid_params) { attributes_for(:other_user) }
  let(:invalid_params) { attributes_for(:other_user, name: nil) }
  let(:update_params_1) { attributes_for(:user, name: "New user") }
  let(:update_params_2) { attributes_for(:other_user, name: "New user") }
  let(:admin_params) { attributes_for(:user, admin: true) }

  # たくさん書きたくないので、テスト内の先頭で定義してしまう
  # ブロックをオブジェクト化、subjectに定義、subject.call で呼び出す
  subject { Proc.new { get :index } }
  subject { Proc.new { get :new } }
  subject { Proc.new { get :show, params: { id: user.id } } }
  subject { Proc.new { get :edit, params: { id: user.id } } }
  subject { Proc.new { post :create, params: { user: valid_params } } }
  # update
  subject { Proc.new { patch :update, params: { id: user.id, user: update_params_1 } } }
  subject { Proc.new { patch :update, params: { id: other_user.id, user: update_params_2 } } }
  subject { Proc.new { patch :update, params: { id: user.id, user: admin_params } }
  # delete
  subject { Proc.new { delete :destroy, params: { id: other_user.id } } }

  # shared_examples の作成

  # assigns
  # インスタンス変数の割り当て(assigns)が正しいこと
  # （引数をとれる）
  shared_examples_for "assigned @value is equal value" do |value|
    it do
      subject.call
      expect(value).to eq value
    end
    # or
    # it { subject.call; expect(value).to eq value }
  end

  # 使い方

  describe "GET #index" do
    subject { proc.new { get :index } }
    # subject は ↓内で call され評価される
    it_behaves_like "assigned @value is equal value" :users # 引数あり
  end

  # 未ログイン時のテストを使いまわしたい

  # # Userモデルの↓のテストとして
  # before_action :logged_in_user,  only: [:index, :edit, :update, :destroy]
  # index/edit/update/delete

  # redirect to url
  shared_examples_for "redirect to url" do |url|
    it { subject.call; expect(response).to redirect_to url }
  end

  # context "when not logged-in"
  shared_context "request login and have messages" do
    it_behaves_like "redirect to url", "/login"
    it { subject.call; expect(flash[:danger]).to eq "Please log in" }
  end

  # 使う時の雛形
  describe "index/edit/update/deletet" do # テストに応じて
    subject { Proc.new { （省略） } }
    context "when logged-in" do
      （省略）
    end
    # abnormal
    context "when not logged-in" do
      include_context "request login and have messages"
    end
  end


```

shared_examples を別ファイルに移動
  ファイルを横断したテストコードの共有・再利用
  spec/support/shared_examples_spec.rb
```ruby
RSpec
spec/support/shared_examples_spec.rb





```
```ruby
Procクラス はブロックをオブジェクト化するためのクラスで、
「何らかの処理（何らかの手続き）」を表します。
Procクラス のインスタンス（Procオブジェクト）を作成する場合は、
Proc.new にブロックを渡します。

Procオブジェクト はオブジェクトとして存在しているだけではまったく実行されません。
Procオブジェクト を実行したい場合はcall メソッドを使います。

# callされるまで評価を遅延できる
# "Hello!"という文字列を返すProcオブジェクトを作成する
hello_proc = Proc.new { 'Hello!' }
# Procオブジェクトを実行する（文字列が返る）
hello_proc.call  #=> "Hello!"


```
