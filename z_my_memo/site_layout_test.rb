
full_title ヘルパーメソッド定義

# app/helpers/application_helper.rb

module ApplicationHelper

  def full_title(page_title = "")
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

end


リスト 5.35:
test環境でもApplicationヘルパーを使えるようにする
test/test_helper.rb
ENV['RAILS_ENV'] ||= 'test'
.
.
.
class ActiveSupport::TestCase
  fixtures :all
  include ApplicationHelper # full_title ヘルパーメソッドが使える
  .
  .
  .
end




# chap05
test/integration/site_layout_test.rb

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'tops/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

end
