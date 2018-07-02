require 'rails_helper'

RSpec.feature "UsersEdit", type: :feature do
  include SupportModule
  subject { page }

  describe "edit" do
    # normal
    context "valid" do
      scenario "edit profile" do
        user = create(:user)
        login_as(user)
        click_link "Settings"
        title_heading("Edit user", "Update your profile")
        should have_link("change", href: "http://gravatar.com/emails")
        expect {
          fill_in_update_profile_form("New Name", "new@example.com")
          click_button "Save changes"
          expect(user.reload.name).to eq "New Name"
          expect(user.reload.email).to eq "new@example.com"
          success_flash("Profile updated")
        }.to change(User, :count).by(0)
      end
    end
    # abnormal
    context "invalid" do
      scenario "fail edit profile" do
        user = create(:user)
        login_as(user)
        click_link "Settings"
        expect {
          fill_in_update_profile_form("", "foo@")
          click_button "Save changes"
          expect(user.reload.name).not_to eq ""
          expect(user.reload.email).not_to eq "foo@"
          error_flash("errors")
        }.to change(User, :count).by(0)
      end
    end

    # フレンドリーフォワーディング
    describe "friendly forwarding" do
      # ログイン後は、目的としていたページに遷移していること
      context "after login (non-login-user)" do
        scenario "render desired page" do
          user = create(:user)
          visit edit_user_path(user)
          error_flash("Please log in")
          current_path(login_path)
          login_as(user)
          current_path(edit_user_path(user))
          title_heading("Edit user", "Update your profile")
        end
      end
    end

    # # admin属性をweb経由で変更できないこと
    # describe "admin-attribute", type: :request do
    #   let(:user) { create(:user) }
    #   # let(:params) do
    #   #   { user: { admin: true, password: user.password,
    #   #             password_confirmation: user.password } }
    #   # end
    #   scenario "not allow change admin-attribute via the web" do
    #     # user = create(:user)
    #     params = { user: { admin: true, password: user.password,
    #                       password_confirmation: user.password } }
    #     # patch user_path(user), params
    #     # page.driver.submit :patch, user_path(user), params {}
    #     expect(user.reload).not_to be_admin
    #   end
    # end
  end
end








# require 'rails_helper'
#
# RSpec.feature "UsersEdit", type: :feature do
#
#   subject { page }
#
#   describe "edit" do
#     include_context "login", :user
#     before { click_link "Settings" }
#     # let(:user) { create(:user) }
#     # before { visit edit_user_path(user) }
#     # let(:submit) { "Save changes" }
#
#     describe "page" do
#       it_behaves_like "title, heading", "Edit user", "Update your profile"
#       it { should have_link("change", href: "http://gravatar.com/emails") }
#     end
#     # abnormal
#     context "with invalid information" do
#       include_context "fill in name, email", "", "foo@"
#       scenario "user increment 0" do
#         expect {
#           click_button "Save changes"
#           have_css('div.alert.alert-danger', text: "errors") # or
#           # expect(page).to have_css('div.alert.alert-danger', text: "errors")
#         }.to change(User, :count).by(0)
#       end
#       # before { click_button submit }
#       # it_behaves_like "error", "errors"
#     end
#     # normal
#     context "with valid infomation" do
#       include_context "fill in name, email", "New Name", "new@example.com"
#       # it "user increment 0" do
#       #   expect { click_button "Save changes" }.to change(User, :count).by(0)
#       # end
#       before { click_button "Save changes" }
#       it_behaves_like "eq", "New Name", "new@example.com"
#       it_behaves_like "success", "Profile updated"
#       it_behaves_like "title, heading", "New Name", "New Name"
#       # it_behaves_like "links in profile-page"
#       # it { should have_current_path(user_path(user)) }
#       # it { should have_link("Log out", href: logout_path) }
#     end
#
#     # # admin属性を操作できないこと
#     # describe "admin-attribute" do
#     #   # it_behaves_like "not allow change admin-attribute via the web"
#     # end
#   end
#
#   # describe "Authorization" do
#   #   describe "friendly forwarding" do
#   #     let(:user) { create(:user) }
#   #     before { post edit_user_path(user) }
#   #     # # なぜかNG
#   #     it_behaves_like "error", "Please login"
#   #     context "after log-in (non-logged-in user)" do
#   #       before { test_login user }
#   #       describe "render desired page" do
#   #         it_behaves_like "title, heading", "Edit user", "Update your profile"
#   #       end
#   #     end
#   #   end
#   # end
#
# end



# require 'rails_helper'
#
# RSpec.feature "UsersEdit", type: :feature do
#   subject { page }
#
#   describe "edit" do
#     include_context "user login"
#     before { visit edit_user_path(user) }
#
#     describe "page" do
#       it { should have_title("Edit user") }
#       it { should have_content("Update your profile") }
#       it { should have_link("change", href: "http://gravatar.com/emails") }
#     end
#
#     context "with invalid information" do
#       let(:invalid_name) { "foo" }
#       let(:invalid_email) { "foo@" }
#       before do
#         fill_in "Name",         with: invalid_name
#         fill_in "Email",        with: invalid_email
#         fill_in "Password",     with: ""
#         fill_in "Confirmation", with: ""
#         click_button "Save changes"
#       end
#       it { should have_content("error") }
#       it { should have_selector("div.alert.alert-danger") }
#     end
#
#     context "with valid infomation" do
#       let(:new_name) { "New Name" }
#       let(:new_email) { "new@example.com" }
#       before do
#         fill_in "Name",         with: new_name
#         fill_in "Email",        with: new_email
#         fill_in "Password",     with: ""
#         fill_in "Confirmation", with: ""
#         click_button "Save changes"
#       end
#       # it { expect(response).to redirect_to user_path(user) }
#       it { should have_current_path(user_path(user)) }
#       it { expect(user.reload.name).to eq new_name }
#       it { expect(user.reload.email).to eq new_email }
#       it { should have_title(new_name) }
#       # it { expect(flash[:success]).to be_present }  # できない
#       it { should have_selector("div.alert.alert-success", text: "Profile updated") }
#       it { should have_link("Log out", href: logout_path) }
#     end
#
#     # ？？？ わからない
#     describe "admin-attribute can not edit via web" do
#       # let(:user) { create(:user) }
#       # let(:params) do
#       #   { user: { admin: true,
#       #             password: user.password,
#       #             password_confirmation: user.password } }
#       # end
#       # it { expect(user).not_to be_admin }
#
#       # test_login user
#       # let(:user_params) { FactoryBot.attributes_for(:user,
#       #  admin: true) }
#       # # sign_in @user
#       #
#       # before do
#       #   test_login user
#       #   patch :update, params: user_params
#       # end
#
#       # before do
#       #   # test_login user, no_capybara: true
#       #   test_login user
#       #   # visit edit_user_path(user)
#       #   patch user_path(user), params
#       # end
#
#       # it { expect(user.reload).not_to be_admin }
#     end
#   end
#
# end
