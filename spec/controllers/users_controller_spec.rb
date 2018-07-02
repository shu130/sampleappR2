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
      it_behaves_like "redirect_to login_url with 'Please log in'"
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
    # # ↓ なぜかNG
    # # be_a_new(User) インスタンス化されいるが未保存
    # it "assigns new @user" do
    #   expect(assigns(:user)).to be_a_new(User)
    # end
  end

  describe "POST #create" do
    # nomal
    context "with valid attributes" do
      subject { Proc.new { post :create, params: { user: valid_params } } }
      it_behaves_like "assigned @value is equal value", :user
      it_behaves_like "create data (increment:1)", User
      it_behaves_like "returns http status", :redirect
      it_behaves_like "have success messages", "Welcome to the Sample App!"
      # # ↓ なぜかNG
      # it_behaves_like "redirect to url", user_path(user)
      it { subject.call; expect(response).to redirect_to user_path(user) }
    end
    # abnomal
    context "with invalid attributes" do
      subject { Proc.new { post :create, params: { user: invalid_params } } }
      # # user.valid?
      # it "should be invalid" do
      #   # user.valid?
      #   user.invalid?
      # end
      it_behaves_like "not change data (increment:0)", User
      it_behaves_like "render template", :new

      # # ↓ なぜかNG
      # it_behaves_like "have error 'can't be blank'", :name
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
        it_behaves_like "not allow edit other-user's-profile"
      end
    end
    # abnormal
    context "when not logged-in" do
      it_behaves_like "redirect_to login_url with 'Please log in'"
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
        it_behaves_like "have success messages", "Profile updated"
        # it_behaves_like "redirect to url", user_path(user)
        it { subject.call; expect(response).to redirect_to user_path(user) }
      end
      # abnomal
      context "with invalid attributes" do
        subject { Proc.new { patch :update, params: { id: user.id, user: invalid_params } } }
        it_behaves_like "not change data (increment:0)", User
        it_behaves_like "render template", :edit
        # # ↓ なぜかNG
        # it_behaves_like "have error 'can't be blank'", :name
      end
      # admin属性を操作できないこと
      context "as admin-user" do
        subject { Proc.new { patch :update, params: { id: other_user.id, user: admin_params } } }
        it_behaves_like "not allow change admin-attribute via the web"
      end
    end
    # abnormal
    context "when not logged-in" do
      # it_behaves_like "redirect_to login_url with 'Please log in'"
      # abnormal
      context "as wrong-user" do
        subject { Proc.new { patch :update, params: { id: other_user.id, user: update_params_2 } } }

        # it_behaves_like "not change data (increment:0)", User
        # it_behaves_like "redirect to url", "/login"
        it_behaves_like "redirect_to login_url with 'Please log in'"
        # 他人のユーザ情報は更新（update）できないこと
        it_behaves_like "not allow update other-user's-profile"
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
      it_behaves_like "redirect_to login_url with 'Please log in'"
      it_behaves_like "not change data (increment:0)", User
    end
  end
end





# # bkup
# require 'rails_helper'
#
# RSpec.describe UsersController, type: :controller do
#
#   # index, show, edit
#   shared_examples_for "http_status_and_template_tests" do |action_symbol|
#     it { expect(response).to have_http_status(:success) }
#     it { expect(response).to render_template action_symbol }
#   end
#   # it_should_behave_like "http_status_and_template_tests", action_symbol
#
#   # index, edit, update, destroy
#   shared_context "logged-in" do
#     let(:user) { create(:user) }
#     before(:each) { log_in_as user }
#   end
#   # include_context "logged-in"
#
#   # show, edit
#   shared_context "get_request" do |action_symbol|
#     # let(:user) { create(:user) }
#     before { get action_symbol, params: { id: user.id } }
#   end
#   # include_context "get_params", action_symbol
#
#   # show, edit
#   shared_context "redirect login-page" do |action_symbol|
#     before { get action_symbol, params: { id: user.id } }
#     it { expect(response).to redirect_to "/login" }
#   end
#   # include_context "redirect login-page", action_symbol
#
#   # show, edit
#   shared_context "have flash messages" do |action_symbol|
#     before { get action_symbol, params: { id: user.id } }
#     it { expect(flash[:danger]).to eq "Please log in" }
#   end
#   # include_context "have flash messages", action_symbol
#
#   describe "GET #index" do
#     let(:user) { create(:user) }
#     let(:other_users) { create_list(:user, 3) }
#     # normal
#     describe "when logged-in" do
#       include_context "logged-in"
#       before(:each) { get :index }
#       it_should_behave_like "http_status_and_template_tests", :index
#       # できなくて諦めたテスト
#       # it "@users に全てのユーザーを割り当てる" do
#       #   expect(assigns(:other_users)).to eq [users]
#       # end
#     end
#     # abnormal
#     describe "when not logged-in" do
#       it "redirect login-page" do
#         expect(response).to redirect_to "/login"
#       end
#       include_context "have flash messages", :index
#     end
#   end
#
#   describe "GET #show" do
#     # let(:user) { create(:user) }
#     # before(:each) { get :show, params: { id: user.id } }
#     include_context "get_request", :show
#     it_should_behave_like "http_status_and_template_tests", :show
#     it "assigns the requested-user to @user" do
#       expect(assigns(:user)).to eq user
#     end
#   end
#
#   describe "GET #new" do
#     # subject { :response }
#     before(:each) { get :new }
#     it_should_behave_like "http_status_and_template_tests", :new
#     it "assigns the new-user to @user" do
#       expect(assigns(:user)).to be_a_new(User)  # or
#       # expect(assigns(:user)).not_to be_nil
#     end
#   end
#
#   describe "POST #create" do
#     let(:param) { attributes_for(:user) }
#     let(:invalid_param) { attributes_for(:user, name: nil) }
#     let(:request_1) { post :create, params: { user: param } }
#     let(:request_2) { post :create, params: { user: invalid_param } }
#     # normal
#     context "when attributes is valid" do
#       it "add a new-user" do
#         expect{ request_1 }.to change(User, :count).by(1)
#       end
#       it "redirect to user-profile-page" do
#         # なぜかNG？
#         # expect(response).to redirect_to user_path(user)
#         # expect(response).to redirect_to User.last
#       end
#       it "have flash messages" do
#         # なぜかNG？
#         # expect(flash[:success]).to eq "Welcome to the Sample App!"
#       end
#     end
#     # abnormal
#     context "when attributes is not valid" do
#       it "does not add a new-user" do
#         # expect{ request_2 }.to change(User, :count).by(0)
#       end
#       it "render signup-page again" do
#         expect(response).to redirect_to "/signup"
#       end
#       it "have flash messages" do
#         expect(assigns(:user).errors.any?).to be_truthy
#       end
#     end
#   end
#
#   describe "GET #edit" do
#     # normal
#     describe "when logged-in" do
#       include_context "logged-in"
#       it_should_behave_like "http_status_and_template_tests", :edit
#       it "assigns the requested-user to @user" do
#         expect(assigns(:user)).to eq user
#       end
#     end
#     # abnormal
#     describe "when not logged-in" do
#       include_context "redirect login-page", :edit
#       include_context "have flash messages", :edit
#     end
#   end
#
#   describe "PATCH #update" do
#     let(:other_user) { create(:other_user) }
#     let(:param) { attributes_for(:user) }
#     let(:new_param) { attributes_for(:user, name: "New user") }
#     let(:admin_param) { attributes_for(:user, admin: true) }
#     let(:request_1) { patch :update, params: { id: user.id, user: param } }
#     let(:request_2) { patch :update, params: { id: user.id, user: new_param } }
#     let(:request_3) { patch :update, params: { id: user.id, user: admin_param } }
#     # normal
#     describe "when logged-in" do
#       include_context "logged-in"
#       it "assigns the requested user to @user" do
#         request_1
#         expect(assigns(:user)).to eq user
#       end
#       it "success update profile" do
#         request_2
#         expect(user.reload.name).to eq "New user"
#       end
#       it "redirect user-profile" do
#         request_2
#         expect(response).to redirect_to user_path(user)
#       end
#       it "have flash message " do
#         request_2
#         expect(flash[:success]).to eq "Profile updated"
#       end
#       it "not allow update other-user-profile" do
#         log_in_as other_user
#         request_2
#         expect(user.reload.name).not_to eq "New user"
#       end
#       it "not allow change admin-attribute to true via the web" do
#         # expect(user.admin).not_to be_truthy
#         request_3
#         expect(user.reload.admin).not_to be_truthy
#       end
#     end
#     # abnormal
#     describe "when not logged-in" do
#       let(:user) { create(:user) }
#       it "redirect login-page" do
#         request_2
#         expect(response).to redirect_to "/login"
#       end
#       it "have flash message " do
#         request_2
#         expect(flash[:danger]).to eq "Please log in"
#       end
#       it "not update user-profile" do
#         request_2
#         expect(user.reload.name).not_to eq "New user"
#       end
#     end
#   end
#
#   describe "DELETE #destroy" do
#     # before(:each) { let(:user) { create(:user) } }
#     let(:user) { create(:user) }
#     let(:admin) { create(:admin) }
#     let(:request) { delete :destroy, params: { id: user.id } }
#     # normal
#     context "when logged-in as admin-user" do
#       before(:each) { log_in_as admin }
#       # 失敗する
#       it "susccess delete user"
#         # expect{ request }.to change(User, :count).by(-1)
#
#       it "redirect to users-index-page" do
#         request
#         expect(response).to redirect_to "/users"  # or
#         # expect(response).to redirect_to users_path
#       end
#       it "have flash messages" do
#         request
#         expect(flash[:success]).to eq "User deleted"
#       end
#     end
#     # abnormal
#     context "when logged-in as non-admin-user"
#       it "does not success delete user"
#       it "redirect to root-page"
#       it "have flash messages"
#   end
#
# end




# assignsメソッド
# index
# @users に複数ユーザーを割り当てる
# show, edit, update, delete
# @userにリクエストされたユーザーを割り当てる
# new, create
# @user に新規ユーザーを割り当てる


        # describe "DELETE #destroy"

# # アウトライン
#   describe "DELETE #destroy"
#     # 正常
#     context "管理者ユーザの場合"
#       it "ユーザー削除 OK"
#       it "リダイレクトされる"
#       it "メッセージが表示される"
#     context "管理者ユーザでは無い場合"
#       it "ユーザー削除 NG"
#       it "リダイレクトされる"
#       it "エラーが表示される"

# # outline
#     describe "DELETE #destroy"
#       # normal
#       context "when logged-in as admin-user"
#         it "success delete profile"
#         it "redirect to root-page"
#         it "have flash messages"
#       # abnormal
#       context "when logged-in as non-admin-user"
#         it "does not success delete profile"
#         it "redirect to root-page"
#         it "have flash messages"


#         # describe "POST#create"
#
# # アウトライン
#   describe "POST#create"
#     context "パラメータの validity OK"
#       it "ユーザー登録 OK"
#       it "リダイレクトされる"
#       it "メッセージが表示される"
#     context "パラメータの validity NG"
#       it "ユーザー登録 NG"
#       it "リダイレクトされる"
#       it "エラーが表示される"

# # outline
#     describe "POST#create"
#       # normal
#       context "when attributes is valid"
#         it "redirect to user-profile-page"
#         it "have flash messages"
#       # abnormal
#       context "when attributes is not valid"
#         it "render signup-page again"
#         it "have flash messages"



#         # describe "GET #index, show, edit"
#
# # アウトライン
#   describe "GET/PATCH #????"
#     # 正常系
#     describe "ログイン済み"
#       it "returns http status"
#       it "renders the :edit template"
#       it "@userが取得できている"
#
#     # 異常系
#     describe "ログイン無し"
#       it "ログイン("/login")にリダイレクトされる"
#       it "flashメッセージが含まれる "Please log in""
#
# # outline
#   describe "GET/PATCH #????"
#     # normal
#     describe "when logged-in"
#       it "returns http status", :success
#       it "renders the :edit template"
#       it "assigns the requested user to @user"
#
#     # abnormal
#     describe "when not logged-in"
#       it "redirect login-page"
#       it "flash have message"
#
#
#                       # describe "PATCH #update"
#
# # アウトライン
#   describe "PATCH #update"
#     # 正常系
#     describe "ログイン済み"
#       it "@userが取得できている"
#       it "@userのプロフィールが更新されている"
#       it "プロフィール画面(show)にリダイレクトされる"
#       it "flashメッセージが含まれる"
#       it "他人のプロフィールの変更が不可"
#       it "web経由でのadmin属性への変更が不可"
#
#     # 異常系
#     describe "ログイン無し"
#       it "ログイン("/login")にリダイレクトされる"
#       it "flashにメッセージが含まれる"
#       it "@userのプロフィール更新が不可"
#
# # outline
#   describe "PATCH #update"
#     # normal
#     describe "when logged-in"
#       it "assigns the requested user to @user"
#       it "updates user-profile"
#       it "redirect user-profile"
#       it "flash have message"
#       it "not allow update other-user-profile"
#       it "not allow change admin-attribute to true via the web"
#
#     # abnormal
#     describe "when not logged-in"
#       it "redirect login-page"
#       it "flash have message"
#       it "not update user-profile"







# minitest
# edit
# test "should redirect edit when not logged in" do
# test "should redirect update when not logged in" do


# tips
# describe FoosController do
#   let(:user) { FactoryGirl.create(:user) }
#   describe 'GET #new' do
#     it_should_behave_like 'authentication required' do
#       let(:action){ get :new }
#       let(:template) {'new'}
#     end
#   end
# end
#
#
# support/authentication_required.rb
#
# require 'spec_helper'
#
# shared_examples 'authentication required' do
#   context 'by anonymous user' do
#     before do
#       action
#     end
#     it { is_expected.to redirect_to signin_path }
#   end
#   context 'by login user' do
#     before do
#       sign_in user
#       action
#     end
#     it { is_expected.to render_template(template) }
#   end
# end


# log_inメソッドどうするの？
# describe 'POST #create' do
#   let(:user) { create(:user) }
#   let(:valid_parameters) do
#     { email: user.email, password: user.password }
#   end
#
#   it 'saves the user ID to the session object' do
#     post :create, session: valid_parameters
#
#     # session[:user_id] で controller 内で設定している値を取り出し
#     expect(session[:user_id]).to eq user.id
#   end
# end



# describe "POST #create" do
#   context "正常な値の時" do
#     it "新規ユーザーを登録できる。" do
#       expect {
#         post :create, {:user => valid_attributes}
#       }.to change(User, :count).by(1)
#     end
# end
