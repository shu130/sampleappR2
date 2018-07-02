

# chap08
リスト 8.27: ユーザー登録後のログインのテスト

# chap07
リスト 7.23: 無効なユーザー登録に対するテスト
リスト 7.25: エラーメッセージをテスト（演習）
リスト 7.33: 有効なユーザー登録に対するテスト
リスト 7.34: flashをテスト（演習）

# chap06
なし


# chap08
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup infomation" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.alert.alert-danger"
    assert_select "div.field_with_errors"
  end

  test "valid signup infomation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.empty?
    assert_select "div.alert.alert-success", text: "Welcome to the Sample App!"
  end
end


# chap07
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup infomation" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.alert.alert-danger"
    assert_select "div.field_with_errors"
  end



end
