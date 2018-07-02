require 'rails_helper'

# RSpec.feature "AuthenticationPages", type: :feature do
RSpec.feature "Authorization", type: :feature do
  include SupportModule
  subject { page }

  describe "in MicropostsController", type: :request do
    context "non-login" do
      describe "create action" do
        # let!(:valid_params) { attributes_for(:user_post) }
        # before { post microposts_path, params: valid_params }
        before { post microposts_path }
        scenario "error with message 'Please log in'" do
          # visit microposts_path
          # なぜかNG
          error_flash "Please log in"
          current_path(login_path)
          # current_path(root_path)
        end
      end
      describe "destroy action" do
        let!(:my_post) { create(:user_post) }
        before { delete micropost_path(my_post) }
        scenario "error with message 'Please log in'" do
          # なぜかNG
          error_flash "Please log in"
          current_path(login_path)
          # current_path(root_path)
        end
      end
    end
  end

  # describe "in UsersController" do
  #   context "non-login" do
  #     describe "visit edit page" do
  #       before { visit edit_user_path(user) }
  #       it { should have_title("Log in") }
  #     end
  #     describe "submit update action" do
  #       before { patch user_path(user) }
  #       it { expect(response).to redirect_to(login_path) }
  #     end
  #     describe "visit user-index page" do
  #       before { visit users_path }
  #       it { should have_title("Log in")}
  #     end
  #   end
  #
  #   context "as wrong user" do
  #     let(:user) { create(:user) }
  #     let(:wrong_user) { create(:user, email: "wrong@example.com")}
  #     # before { valid_login_no_capybara user }
  #     before { test_login user }
  #
  #     describe "submit GET Users#edit" do
  #       before { get edit_user_path(wrong_user) }
  #       it { expect(response.body).not_to match(full_title "Edit user") }
  #       it { expect(response).to redirect_to root_url }
  #     end
  #
  #     describe "submit PATCH Users#update" do
  #       before { patch user_path(wrong_user) }
  #       it { expect(response).to redirect_to root_path }
  #     end
  #   end
  #
  #   context "as non-admin user" do
  #     let(:admin_user) { create(:user) }
  #     let(:user) { create(:user) }
  #     # before { valid_login_no_capybara user }
  #     before { test_login user }
  #
  #     describe "submit DELETE Users#destroy" do
  #       before { delete user_path(admin_user) }
  #       it { expect(response).to redirect_to root_url }
  #     end
  #   end
  # end
end







# require 'rails_helper'
#
# RSpec.feature "AuthenticationPages", type: :feature do
#
#   subject { page }
#
#   describe "login" do
#     before { visit login_path }
#
#     it { should have_title("Log in") }
#     it { should have_content("Log in") }
#
#     context "with invalid infomation" do
#       before { click_button "Log in" }
#
#       it { should have_title("Log in") }
#       it { should have_selector("div.alert.alert-danger", text: "Invalid") }
#
#       context "after visit another page" do
#         before { click_link "Home" }
#         it { should_not have_selector("div.alert.alert-danger") }
#       end
#     end
#
#     context "with valid infomation" do
#       let(:user) { create(:user) }
#       before { test_login user }
#
#       it { should have_title(user.name) }
#       it { should have_link("Users",    href: users_path) }
#       it { should have_link("Profile",  href: user_path(user)) }
#       it { should have_link("Settings", href: edit_user_path(user)) }
#       it { should have_link("Log out",  href: logout_path) }
#       it { should_not have_link("Log in",  href: login_path) }
#
#       context "followed by logout" do
#         # １回目のログアウト
#         before { click_link "Log out" }
#         it { should have_link("Log in") }
#         # ２回目のログアウト
#         # ... どう書く？
#       end
#
#       # context "with remember_me" do
#       #   log_in_as(user, remember_me: '1')
#       #   click_button "Log out"
#       #   log_in_as(user, remember_me: '0')
#       #   # ↓ minitest では assert_empty cookies['remember_token']
#       #   its(:remember_token) { should be_blank }
#       # end
#       #
#       # context "without remember_me" do
#       # end
#     end
#   end
#
#   describe "authorization" do
#     context "for non-logged-in users" do
#       let(:user) { create(:user) }
#
#       context "when attemp to visit protected page" do
#         before { visit edit_user_path(user) }
#         it { should have_title("Log in") }
#         # it { expect(response).to redirect_to login_url }
#         # it { expect(response.body).not_to match(full_title "Edit user") }
#         # it { should have_selector('div.alert.alert-danger', text: 'Please login.') }
#
#         describe "after login" do
#           before { test_login user }
#           it "should render desired protected page" do
#             expect(page).to have_title("Edit user")
#           end
#         end
#       end
#
#       context "in UsersController" do
#         describe "visit edit page" do
#           before { visit edit_user_path(user) }
#           it { should have_title("Log in") }
#         end
#         describe "submit update action" do
#           before { patch user_path(user) }
#           it { expect(response).to redirect_to(login_path) }
#         end
#         describe "visit user-index page" do
#           before { visit users_path }
#           it { should have_title("Log in")}
#         end
#       end
#     end
#
#     context "as wrong user" do
#       let(:user) { create(:user) }
#       let(:wrong_user) { create(:user, email: "wrong@example.com")}
#       # before { valid_login_no_capybara user }
#       before { test_login user }
#
#       describe "submit GET Users#edit" do
#         before { get edit_user_path(wrong_user) }
#         it { expect(response.body).not_to match(full_title "Edit user") }
#         it { expect(response).to redirect_to root_url }
#       end
#
#       describe "submit PATCH Users#update" do
#         before { patch user_path(wrong_user) }
#         it { expect(response).to redirect_to root_path }
#       end
#     end
#
#     context "as non-admin user" do
#       let(:admin_user) { create(:user) }
#       let(:user) { create(:user) }
#       # before { valid_login_no_capybara user }
#       before { test_login user }
#
#       describe "submit DELETE Users#destroy" do
#         before { delete user_path(admin_user) }
#         it { expect(response).to redirect_to root_url }
#       end
#     end
#   end
# end
