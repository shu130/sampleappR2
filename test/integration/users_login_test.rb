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
