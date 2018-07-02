# RailsチュートリアルテストをRSpecでやってみる [単体テスト][コントローラ]
<!--
### MicropostsControllerコントローラ 単体テスト（１３章）
 -->

対象

コントローラ  | スペックファイル名  | テキストの中で登場する章
--|---|--
Micropostsコントローラ  | microposts_controller_spec.rb  | １３章

ファクトリの作成

Userモデルに対して依存（belongs_to）の関係
```ruby
class User < ActiveRecord::Base
  has_many :microposts
end
class Micropost < ActiveRecord::Base
  belongs_to :user
end
```
<!-- Postモデルのデータ生成時に、依存しているデータの生成も併せて行えます。 -->

データ生成時に、依存している側（User）のデータも生成されるようにする

```ruby
spec/factories/sample_microposts.rb

FactoryBot.define do
  # 自分のマイクロポスト
  factory :user_post, class: Micropost do
    content { Faker::Lorem.sentence(5) }
    association :user, factory: :user
    # association :[関連するモデル名], factory: :[データ名]
  end
  # 他人のマイクロポスト
  factory :other_user_post, class: Micropost do
    content { Faker::Lorem.sentence(5) }
    association :user, factory: :other_user
  end
end
```

<!-- Userモデル側のファクトリの user は↓なので、
```ruby
spec/factories/users.rb

  factory :user, class: User do
    name     "Example user"
    email    "user@example.com"
    password              "foobar"
    password_confirmation "foobar"
    admin false
  end
``` -->

使い方

`FactoryBot.create(:user_post)` をすると、↓のようになる
```test
irb(main):003:0* my_post = FactoryBot.create(:user_post)
=> #<Micropost id: 1, content: "Doloremque et eaque fugit tempora.", user_id: 1, created_at: "2018-06-22 06:35:19", updated_at: "2018-06-22 06:35:19">
```
`FactoryBot.attributes_for(:user_post)` をすると、↓のようになる
```test
irb(main):009:0* params = FactoryBot.attributes_for(:my_post)
=> {:content=>"Ut explicabo accusamus atque dolore possimus consequatur corporis fugit."}
```


アウトライン
microposts_controller_spec.rb
<!-- 個別
（Micropostsコントローラ） -->
```ruby
#create
  正常系 login
    正常系
      新規マイクロポストを登録（create）OK
      データ数が増加すること(increment:1)
    異常系（content: nil）
      データ数に変化がないこと(increment:0)
  異常系 login
    ログイン画面に遷移し、メッセージが出力される
#delete
  正常系 login
    正常系
      自分のマイクロポストの削除（delete）が OK
      データ数が減少すること(increment:-1)
    異常系
      他人のマイクロポストは削除（delete）が NG
      データ数に変化がないこと(increment:0)
  異常系
    ログイン画面に遷移し、メッセージが出力される
```
```ruby
  describe "POST #create"
    context "when logged-in"
      context "with valid attributes"
      context "with invalid attributes"
    context "when not logged-in"

  describe "DELETE #destroy"
    context "when logged-in"
      context "as rigtht-user"
      context "as wrong-user"
    context "when not logged-in"
```

使用する変数の整理
変数はまとめて先頭に定義してしまう

変数（インスタンス化） | 使い方（アクション）
--|--
my_post  | 自分のマイクロポストの削除（delete）OK
other_post  | 他人のマイクロポストの削除（delete）NG

変数（パラメータハッシュ） | 使い方（アクション）
--|--
valid_params  | マイクロポストの登録（create）OK
invalid_params  | マイクロポストの登録（create）NG
<!--
```ruby
  let(:my_post) { create(:my_post) }
  let(:other_user_post) { create(:other_user_post) }
  let(:valid_params) { attributes_for(:my_post) }
  let(:invalid_params) { attributes_for(:my_post, content: nil) }
``` -->

完成したテスト
```ruby
microposts_controller_spec.rb

require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do

  # let! で DBに保存し、レコードが２つある状態にしておく
  let!(:my_post) { create(:user_post) }
  let!(:other_post) { create(:other_user_post) }
  let(:valid_params) { attributes_for(:user_post) }
  let(:invalid_params) { attributes_for(:user_post, content: nil) }

  # ログイン用のユーザ
  let(:user) { create(:user) }
  before(:each) { allow(User).to receive(:find_by).and_return(user) }

  describe "POST #create" do
    # nomal
    context "when logged-in" do
      before(:each) { log_in_as user }
      # nomal
      context "with valid attributes" do
        subject { Proc.new { post :create, params: { micropost: valid_params } } }
        it_behaves_like "assigned @value is equal value", :micropost
        it_behaves_like "create data (increment:1)", Micropost
        it_behaves_like "returns http status", :redirect
        it_behaves_like "redirect to url", "/"
        it_behaves_like "have success messages", "Micropost created"
      end
      # abnomal
      context "with invalid attributes" do
        subject { Proc.new { post :create, params: { micropost: invalid_params } } }
        it_behaves_like "assigned @value is equal value", :micropost
        it_behaves_like "not change data (increment:0)", Micropost
        it_behaves_like "render template", :home
      end
    end
    # abnormal
    context "when not logged-in" do
      subject { Proc.new { post :create, params: { micropost: valid_params } } }
      include_context "redirect_to login_url with error messages"
      it_behaves_like "not change data (increment:0)", Micropost
    end
  end

  describe "DELETE #destroy" do
    # normal
    context "when logged-in" do
      before(:each) { log_in_as user }
      # nomal
      context "as rigtht-user" do
        subject { Proc.new { delete :destroy, params: { id: my_post.id } } }
        it_behaves_like "assigned @value is equal value", :my_post
        it_behaves_like "delete data (increment:-1)", Micropost
        it_behaves_like "returns http status", :redirect
        it_behaves_like "redirect to url", "/"
        it_behaves_like "have success messages", "Micropost deleted"
      end
      # abnormal
      context "as wrong-user" do
        subject { Proc.new { delete :destroy, params: { id: other_post.id } } }
        it "assigned @micropost is not equal micropost" do
          subject.call; expect(:other_post).not_to eq other_post
        end
        it_behaves_like "not change data (increment:0)", Micropost
      end
    end
    # abnormal
    context "when not logged-in" do
      subject { Proc.new { delete :destroy, params: { id: other_post.id } } }
      include_context "redirect_to login_url with error messages"
      it_behaves_like "not change data (increment:0)", Micropost
    end
  end
end
```
結果
```test
MicropostsController
  POST #create
    when logged-in
      with valid attributes
        behaves like assigned @value is equal value
          should eq :micropost
        behaves like create data (increment:1)
          should change #count by 1
        behaves like returns http status
          should respond with a redirect status code (3xx)
        behaves like redirect to url
          should redirect to "/"
        behaves like have success messages
          should eq "Micropost created"
      with invalid attributes
        behaves like assigned @value is equal value
          should eq :micropost
        behaves like not change data (increment:0)
          should change #count by 0
        behaves like render template
          should render template home
    when not logged-in
      behaves like redirect to url
        should redirect to "/login"
      behaves like have error messages
        should eq "Please log in"
      behaves like not change data (increment:0)
        should change #count by 0
  DELETE #destroy
    when logged-in
      as rigtht-user
        behaves like assigned @value is equal value
          should eq :my_post
        behaves like delete data (increment:-1)
          should change #count by -1
        behaves like returns http status
          should respond with a redirect status code (3xx)
        behaves like redirect to url
          should redirect to "/"
        behaves like have success messages
          should eq "Micropost deleted"
      as wrong-user
        assigned @micropost is not equal micropost
        behaves like not change data (increment:0)
          should change #count by 0
    when not logged-in
      behaves like redirect to url
        should redirect to "/login"
      behaves like have error messages
        should eq "Please log in"
      behaves like not change data (increment:0)
        should change #count by 0

Finished in 7.08 seconds (files took 2.36 seconds to load)
21 examples, 0 failures
```
