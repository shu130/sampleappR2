

２つのバグ対応
# 9.1.4 ２つの目立たないバグ

バグその１
複数タブ/ウィンドウ での ログアウト問題
  両方でアプリ起動（ページを開いている）している状態で、
  それぞれ "Log out" をクリックするとエラーになる。

原因
"Log out" をクリックすると log_outメソッド が実行され current_user が nil になる

バグその２
種類の違うブラウザ（Chrome/Firefoxなど）でのログアウト問題
  両方でアプリ起動（ページを開いている）している状態で、
  ブラウザ１ では ログアウトのみ実施で、
  ブラウザ２ では ログアウト未実施で アプリ終了し、
  ブラウザ２ で 再度アプリを起動し、同じページ("users/【id】")を開こうとすると、エラー（例外）が発生してしまう。

原因
  ブラウザ２ に ↓ cookies が 残っている為、署名付きid で ユーザ特定し、
  authenticated?メソッド で nil が発生するため
  cookies.signed[:user_id])
  cookies[:remember_token]



  def log_out
    forget_in_db_ck(current_user)
    session.delete(:user_id)
    @current_user = nil if logged_in?
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def forget_in_db_ck(user)
    user.forget_in_db
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end





# chap09
require 'rails_helper'

RSpec.feature "UsersLogin", type: :feature do

  subject { page }

  describe "login" do
    before { visit login_path }

    it { should have_title("Log in") }
    it { should have_content("Log in") }

    context "with invalid infomation" do
      before { click_button "Log in" }

      it { should have_title("Log in") }
      it { should have_selector("div.alert.alert-danger", text: "Invalid") }

      context "after visit another page" do
        before { click_link "Home" }
        it { should_not have_selector("div.alert.alert-danger") }
      end
    end

    context "with valid infomation" do
      let(:user) { create(:user) }
      before { test_login user }

      it { should have_title(user.name) }
      it { should have_link("Users",    href: users_path) }
      it { should have_link("Profile",  href: user_path(user)) }
      it { should have_link("Settings", href: edit_user_path(user)) }
      it { should have_link("Log out",  href: logout_path) }
      it { should_not have_link("Log in",  href: login_path) }

      context "followed by logout" do
        # "Log out" をクリック １回目
        context "logout by one browser(Chrome)" do
          before { click_link "Log out" }
          it { should_not have_link("Log out") }
          it { should have_link("Log in") }
          # 現在のページが特定のパスであることを検証
          # it { expect(current_path).to eq root_path }
          it { should have_current_path(root_path)}
        end
        # "Log out" をクリック ２回目
        context "logout by other browser(Firefox)" do
          before { click_link "Log out" }
          it { should_not have_link("Log out") }
          it { should have_link("Log in") }
          # it { expect(current_path).to eq root_path }
          it { should have_current_path(root_path)}
        end
      end

      # context "with remember_me" do
      #   log_in_as(user, remember_me: '1')
      #   click_button "Log out"
      #   log_in_as(user, remember_me: '0')
      #   # ↓ minitest では assert_empty cookies['remember_token']
      #   its(:remember_token) { should be_blank }
      # end
      #
      # context "without remember_me" do
      # end
    end
  end
end
