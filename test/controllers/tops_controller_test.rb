require 'test_helper'

class TopsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "#home" do
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "#help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "#about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "#contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

end
