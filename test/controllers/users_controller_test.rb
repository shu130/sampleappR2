require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  # index
  test "should redirect index when not logged-in" do
    get users_path
    assert_redirected_to login_url
    follow_redirect!
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select "div.alert.alert-danger", text: "Please log in"
  end

  # new
  test "should get new" do
    get signup_path
    assert_response :success
    assert_template 'users/new'
  end

  # show
  test "should get show" do
    get user_path(@user)
    assert_response :success
    assert_template 'users/show'
  end

  # edit
  test "should redirect edit when not logged-in" do
    get edit_user_path(@user)
    assert_redirected_to login_url
    follow_redirect!
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select "div.alert.alert-danger", text: "Please log in"
  end

  # update
  test "should redirect update when not logged-in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_redirected_to login_url
    follow_redirect!
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select "div.alert.alert-danger", text: "Please log in"
  end

  # edit
  test "should redirect edit when logged in as wrong-user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_redirected_to root_url
    follow_redirect!
    assert_template '/'
    assert flash.empty?
  end

  # update
  test "should redirect update when logged in as wrong-user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_redirected_to root_url
    follow_redirect!
    assert_template '/'
    assert flash.empty?
  end

  # strong parameter
  test "should not allow admin-attribute to be edited via web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: {
                                    password: 'password',
                                    password_confirmation: 'password',
                                    admin: true
                                    } }
    assert_not @other_user.reload.admin?
  end

  # destroy

  test "should redirect destroy when not logged-in" do
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged-in as non-admin" do
    log_in_as(@other_user)
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged-in as admin" do
    log_in_as(@user)
    assert_difference "User.count", -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to users_url
    follow_redirect!
    assert_template 'users/index'
    assert_select "div.alert.alert-success", text: "User deleted"
  end

end
