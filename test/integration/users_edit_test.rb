require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccess edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select "div#error_explanation"
    assert_select "div.alert.alert-danger"
    assert_select "div.field_with_errors"
  end

  test "success edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  # ？？？ 失敗する フレンドリーフォワーディング
  test "sccess edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_redirected_to login_url(@user)
    follow_redirect!
    assert_template 'sessions/new'
    assert_select "div.alert.alert-danger", text: "Please log in"
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert_template 'users/edit'

    # 名前 と メールアドレス を更新してみる
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: ""
      }}
    assert_not flash.empty?
    assert_select "div.alert.alert-success", text: "Profile updated"
  end

end
