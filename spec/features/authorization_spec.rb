require 'rails_helper'

# RSpec.feature "AuthenticationPages", type: :feature do
RSpec.feature "Authorization", type: :feature do

  include SupportModule
  include_context "setup"

  subject { page }

  describe "in UsersController", type: :request do
    # 未ログイン
    context "non-login" do
      describe "index" do
        subject { Proc.new { get users_path } }
        it_behaves_like "error message", "Please log in"
        it_behaves_like "redirect to path", "/login"
      end
      describe "edit" do
        subject { Proc.new { get edit_user_path(user) } }
        it_behaves_like "error message", "Please log in"
        it_behaves_like "redirect to path", "/login"
      end
      describe "update"do
        subject { Proc.new { patch user_path(user), params: { user: update_params_1 } } }
        # subject { Proc.new { patch user_path(user), update_params_1 } }
        it_behaves_like "error message", "Please log in"
        it_behaves_like "redirect to path", "/login"
      end
      describe "destroy"do
        subject { Proc.new { delete user_path(other_user) } }
        it_behaves_like "redirect to path", "/login"
        it "decrease: 0" do
          expect { subject.call }.to change(User, :count).by(0)
        end
      end
    end
    # 非管理者ユーザ
    context "non-admin" do
      describe "destroy" do
        before { login_as(user) }
        scenario "decrease: 0" do
          expect {
            # visit users_path
            click_link "Users"
            not have_link('delete', href: user_path(User.first))
            not have_link('delete', href: user_path(User.second))
          }.to change(User, :count).by(0)
        end
      end
    end
    # 管理者ユーザ
    context "admin" do
      describe "destroy" do
        before { login_as(admin) }
        scenario "decrease: 1" do
          expect {
            # visit users_path
            click_link "Users"
            # expect(page).to have_link "delete", href: user_path(User.first)
            have_link('delete', href: user_path(User.first))
            have_link('delete', href: user_path(User.second))
            not have_link('delete', href: user_path(admin))
            click_link "delete", match: :first
          }.to change(User, :count).by(-1)
        end
      end
    end
  end

  describe "in MicropostsController", type: :request do
    context "non-login" do
      describe "create" do
        # let!(:valid_params) { attributes_for(:user_post) }
        # before { post microposts_path, params: valid_params }
        before { post microposts_path }
        scenario "error message 'Please log in'" do
          expect {
          error_flash "Please log in"
          current_path(login_path)
          }
        end
      end
      describe "destroy" do
        let!(:my_post) { create(:user_post) }
        before { delete micropost_path(my_post) }
        scenario "error with message 'Please log in'" do
          # なぜかNG
          expect {
          error_flash "Please log in"
          current_path(login_path)
          }
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
