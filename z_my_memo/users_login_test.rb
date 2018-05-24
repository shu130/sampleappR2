
# chap08
# outline
test "login with invalid infomation"
test "login with valid infomation"
test "login fowllowed by logout"
test "login with remembering"
test "login without remembering"


# chap08

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid infomation" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid infomation" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'} }
    assert_redirect_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", user_path(@user)
  end

  test "login fowllowed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'}
    assert_redirect_to @user
    assert logged_in?
    follow_redirect!
    assert_template 'users/show'
    # １回目のログアウトのクリック
    delete logout_path
    assert_not logged_in?
    assert_redirect_to root_url
    # ２回目のログアウトのクリック
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    # assert_not_empty cookies['remember_token']
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '1')
    delete logout_path
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

end







# chap07
# outline

test "login with invalid infomation"
test "login with valid infomation"
test "login fowllowed by logout"


# chap07
require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid infomation" do

  end

  test "login with valid infomation" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'} }
    assert_redirect_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", user_path(@user)
  end

  test "login fowllowed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'}
    assert_redirect_to @user
    assert logged_in?
    follow_redirect!
    assert_template 'users/show'
    delete logout_path
    assert_not logged_in?
    assert_redirect_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end





end
