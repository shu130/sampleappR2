require 'rails_helper'

RSpec.feature "UsersSignup", type: :feature do
  include SupportModule
  subject { page }

  describe "signup" do
    context "valid" do
      scenario "create new user (increment: 1)" do
        visit signup_path
        expect {
          # fill_in_signup_valid
          fill_in_signup_form(:user)
          click_button "Create my account"
          success_flash "Welcome to the Sample App!"
          # サインアップ後は profile-page へ遷移すること
          current_path(user_path(User.last))
          title_heading_of_profile_page(User.last)
        }.to change(User, :count).by(1)
      end
    end
    # abnomal
    context "invalid" do
      scenario "fail create new user (increment: 0)" do
        visit signup_path
        expect {
          # fill_in_signup_invalid
          fill_in_signup_form(:user, invalid: true)
          click_button "Create my account"
          error_flash "errors"
          error_flash
          current_path(users_path)
          title_heading("Sign up")
        }.to change(User, :count).by(0)
      end
    end
  end
end





# require 'rails_helper'
#
# RSpec.feature "UsersSignup", type: :feature do
#
#   subject { page }
#
#   describe "signup" do
#     before { visit signup_path }
#     let(:submit) { "Create my account" }
#     # abnomal
#     context "error" do
#       include_context "fill in invalid infomation"
#       it "user increment 0" do
#         expect { click_button submit }.to change(User, :count).by(0)
#       end
#       # エラーメッセージ出力
#       context "after submit" do
#         before { click_button submit }
#         it_behaves_like "title, heading", "Sign up", "Sign up"
#         it_behaves_like "error", "errors"
#       end
#     end
#     # normal
#     context "success" do
#       include_context "fill in valid infomation"
#       it "user increment 1" do
#         expect { click_button submit }.to change(User, :count).by(1)
#       end
#       # サインアップ後はプロフィールページへ遷移すること
#       context "after save user" do
#         before { click_button submit }
#         it_behaves_like "have user title, heading"
#         it_behaves_like "links in profile-page"
#         it_behaves_like "success", "Welcome to the Sample App!"
#       end
#     end
#   end
# end




# # 結果
# UsersSignup
#   signup
#     error
#       user increment 0
#       after submit
#         behaves like have title, heading
#           should have title "Sign up"
#           should have visible css "h1" with text "Sign up"
#         behaves like error
#           should have visible css "div#error_explanation"
#           should text "errors"
#           should have visible css "div.alert.alert-danger"
#     success
#       user increment 1
#       after save user
#         behaves like have user title, heading
#           should have title "Example User"
#           should have visible css "h1" with text "Example User"
#         behaves like links in profile-page
#           should have visible link "Users"
#           should have visible link "Profile"
#           should have visible link "Settings"
#           should have visible link "Log out"
#           should not have visible link "Log in"
#         behaves like success
#           should have visible css "div.alert.alert-success" with text "Welcome to the Sample App!"
#
# Finished in 6.12 seconds (files took 1.67 seconds to load)
# 15 examples, 0 failures







# ボツ
# require 'rails_helper'
#
# RSpec.feature "UsersSignup", type: :feature do
#
#   subject { page }
#
#   describe "Sign up" do
#     # visit root_path
#     before do
#       visit root_path
#       click_link "Sign up"
#     end
#     let(:submit) { "Create my account" }
#     # abnomal
#     context "invalid info" do
#       include_context "fill in invalid infomation"
#       it "user increment 0" do
#         expect { click_button submit }.to change(User, :count).by(0)
#       end
#       it_behaves_like "title, heading", "Sign up", "Sign up"
#       # it { should have_content("errors") }
#       # it { should have_css('div#error_explanation') }
#       # it { should have_selector('div.alert.alert-danger') }
#       # it_behaves_like "error", "errors"
#     end
#     # normal
#     context "valid info" do
#       include_context "fill in valid infomation"
#       it "user increment 1" do
#         expect { click_button submit }.to change(User, :count).by(1)
#       end
#       # let(:user) { User.find_by(email: "user@example.com") }
#       # it { should have_title(user.name) }
#       # it { should have_content(user.name) }
#       # it_behaves_like "have user title, heading"
#       it_behaves_like "success", "Welcome to the Sample App!"
#       # it_behaves_like "links in profile-page"
#     end
#   end
# end
