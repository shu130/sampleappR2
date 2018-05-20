require 'test_helper'

class TopsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "#home" do
    get root_url
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "#help" do
    get tops_help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "#about" do
    get tops_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "#contact" do
    get tops_contact_url
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

end
