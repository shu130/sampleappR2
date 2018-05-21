

ApplicationHelper
  full_title
    should include the page title
    should include the base title
    should not include a bar for the home page



# chap05

リスト5.38 full_titleヘルパーに対するテスト。
spec/helpers/application_helper_spec.rb

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe "full_title" do
    it "should include the page title" do
      expect(full_title("foo")).to match(/foo/)
    end

    it "should include the base title" do
      expect(full_title("foo")).to match(/Ruby on Rails Tutorial Sample App/)
    end

    it "should not include a bar for the home page" do
      expect(full_title("")).not_to match(/\|/)
    end
  end
end
