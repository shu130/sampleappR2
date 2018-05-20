requre 'test_helper'

class TopsControllerTest < ActionDispatch::IntegrationTest

  test "#home" do
    get root_url
    assert_response :success
  end

  test "#help" do
    get tops_help_url
    assert_response :success
  end

  test "#about" do
    get tops_about_url
    assert_response :success
  end

  test "#contact" do
    get tops_contact_url
    assert_response :success
  end
