require 'rails_helper'

RSpec.feature "UsersLogin", type: :feature do

  include SupportModule
  include_context "setup"

  subject { page }

  describe "log in" do
    before { visit "/login" }
    # loginフォームが正しいこと
    it_behaves_like "login-form have right css"
    # ログイン情報が 有効
    context "valid info" do
      scenario "success log in" do
        # user = create(:user)
        visit "/login"
        fill_in_login_form(user) # support_module
        click_button "Log in"
        # title_heading_of_profile_page(user) # support_module
        should have_title(user.name)
        should have_css('h1', text: user.name)
        should have_current_path(user_path(user))
        # current_path(user_path(User.last)) # support_module
      end
    end
    # ログイン情報が 無効
    context "invalid info" do
      scenario "fail log in" do
        visit login_path
        fill_in_login_form(user, invalid: true)
        click_button "Log in"
        error_messages "Invalid email/password combination"
        # title_heading("Log in")
        should have_title("Log in")
        should have_css("h1", text: "Log in")
        should have_current_path("/login")
      end
    end
  end

  # ログアウト
  describe "log out" do
    # ログアウトが正常にできること
    describe "success log out" do
      # 同じサイトを 複数tab/window で開いている状態をシュミレート
      context "when open in some browser-tab(or window)" do
        # "Log out" をクリック １回目をシュミレート
        scenario "1st time log out" do
          login_as(user)
          click_link "Log out"
          should have_current_path(root_path)
        end
        # "Log out" をクリック ２回目をシュミレート
        # HTTPリクエストを直接送るので、type: :request オプションをつける
        scenario "2nd time log out", type: :request do
          delete logout_path(user)
          should have_current_path(root_path)
        end
      end
    end
  end
end


# # アウトライン
# # spec/features/users_login_spec.rb

# RSpec.feature "UsersLogin", type: :feature do
#
#   # ログインページ
#   describe "log in"
#     # loginフォームが正しいこと
#     it_behaves_like "log in form have right css"
#     # 情報が valid
#     context "valid info"
#       # 成功
#       scenario "success log in"
#     # 情報が invalid
#     context "invalid info"
#       # 失敗
#       scenario "fail log in"
#   # ログアウト
#   describe "log out"
#     # ログアウトが正常にできること
#     describe "success log out"
#       # 同じサイトを 複数tab/window で開いている状態をシュミレート
#       context "when open in some browser-tab(or window)"
#       # "Log out" をクリック １回目をシュミレート
#       scenario "1st time log out"
#       # "Log out" をクリック ２回目をシュミレート
#       scenario "2nd time log out"
# end



# require 'rails_helper'
#
# RSpec.feature "UsersLogin", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   describe "log in" do
#     # loginフォームが正しいこと
#     scenario "login-form is correct" do
#       visit login_path
#       login_form_css  # support_module
#     end
#     # ログイン情報が 有効
#     context "valid info" do
#       scenario "success log in" do
#         # user = create(:user)
#         visit "/login"
#         fill_in_login_form(user) # support_module
#         click_button "Log in"
#         # title_heading_of_profile_page(user) # support_module
#         should have_title(user.name)
#         should have_selector('h1', text: user.name)
#         should have_current_path(user_path(user))
#         # current_path(user_path(User.last)) # support_module
#       end
#     end
#     # ログイン情報が 無効
#     context "invalid info" do
#       scenario "fail log in" do
#         # user = create(:user)
#         visit login_path
#         fill_in_login_form(user, invalid: true)
#         click_button "Log in"
#         error_flash "Invalid email/password combination"
#         # title_heading("Log in")
#         should have_title("Log in")
#         should have_css("h1", text: "Log in")
#         should have_current_path("/login")
#       end
#     end
#   end
#
#   # ログアウト
#   # HTTPリクエストを直接送るので、type: :request オプションをつける
#   describe "log out", type: :request do
#     # ログアウトが正常にできること
#     describe "success log out" do
#       # 同じサイトを 複数tab/window で開いている状態をシュミレート
#       context "when open in some browser-tab(or window)" do
#         # "Log out" をクリック １回目をシュミレート
#         scenario "1st time log out" do
#           login_as(user)
#           click_link "Log out"
#           should have_current_path(root_path)
#         end
#          # "Log out" をクリック ２回目をシュミレート
#         scenario "2nd time log out" do
#           delete logout_path(user)
#           should have_current_path(root_path)
#         end
#       end
#     end
#   end
# end







# require 'rails_helper'
#
# RSpec.feature "UsersLogin", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   describe "log in" do
#     # loginフォームが正しいこと
#     scenario "login-form is correct" do
#       visit login_path
#       login_form_css  # support_module
#     end
#     # ログイン情報が 有効
#     context "valid info" do
#       scenario "success log in" do
#         # user = create(:user)
#         visit "/login"
#         fill_in_login_form(user) # support_module
#         click_button "Log in"
#         title_heading_of_profile_page(user) # support_module
#         current_path(user_path(User.last)) # support_module
#       end
#     end
#     # ログイン情報が 無効
#     context "invalid info" do
#       scenario "fail log in" do
#         # user = create(:user)
#         visit login_path
#         fill_in_login_form(user, invalid: true)
#         click_button "Log in"
#         error_flash "Invalid email/password combination"
#         # title_heading("Log in")
#         should have_title("Log in")
#         should have_css("h1", text: "Log in")
#         current_path(login_path)
#       end
#     end
#   end
#
#   # ログアウト
#   # HTTPリクエストを直接送るので、type: :request オプションをつける
#   describe "log out", type: :request do
#     # ログアウトが正常にできること
#     describe "success log out" do
#       # 同じサイトを 複数tab/window で開いている状態をシュミレート
#       context "when open in some browser-tab(or window)" do
#         # "Log out" をクリック １回目をシュミレート
#         scenario "1st time log out" do
#           login_as(user)
#           click_link "Log out"
#           current_path(root_path)
#         end
#          # "Log out" をクリック ２回目をシュミレート
#         scenario "2nd time log out" do
#           delete logout_path(user)
#           current_path(root_path)
#         end
#       end
#     end
#   end
# end





      # # わから〜ん
      # context "remember_me checkbox on" do
      #   let(:user) { create(:user) }
      #   let(:remember_digest) { User.digest('foobar') }
      #
      #   # クッキーを保存してログイン
      #   before { log_in_as(user, remember_me: '1') }
      #   # before { test_login user, remember_me: true, no_capybara: true }
      #   # before { test_login user, remember_me: true, no_capybara: false }
      #   # before { test_login user }
      #
      #   it { expect(user.remember_token).to be_present }
      #
      #   # # チェックボックスがチェックされているか判定
      #   # it { expect(page).to have_checked_field("Remember me on this computer") }
      #   # it { should have_checked_field("Remember me on this computer") }
      #   # it "should be checked" do
      #   #   checkbox = find("#session_remember_me")
      #   #   expect(checkbox).to be_checked
      #   # end
      #
      #   # specify { expect(remember_token).to eq user.remember_token }
      #   # it { expect(response.cookies['remember_token']).to be_present }
      #   # it { expect(remember_token).to be_present }
      #   # it { expect(response.cookies['remember_token']).to eq user.remember_token }
      # end




# require 'rails_helper'
#
# RSpec.feature "UsersLogin", type: :feature do
#
#   subject { page }
#
#   describe "login" do
#     before { visit login_path }
#     it_behaves_like "title, heading", "Log in", "Log in"
#     it_behaves_like "have login-form"
#
#     # ログイン情報が 無効
#     context "with invalid infomation" do
#       before { click_button "Log in" }
#       it_behaves_like "title, heading", "Log in", "Log in"
#       it_behaves_like "error", "Invalid"
#       # it { should have_current_path(login_path) }
#       context "after visit another page" do
#         before { click_link "Home" }
#         it_behaves_like "no error", "Invalid"
#         # it { should_not have_selector("div.alert.alert-danger") }
#       end
#     end
#
#     # ログイン情報が 有効
#     context "with valid infomation" do
#       # let(:user) { create(:user) }
#       # before { test_login user }
#       include_context "user login"
#       describe "render user-profile" do
#         it { should have_current_path(user_path(user)) }
#         # it_behaves_like "title, heading", user.name, user.name
#         it { should have_title(user.name) }
#         it { should have_content(user.name) }
#         it_behaves_like "links in profile-page"
#         # it { should have_link("Users",    href: users_path) }
#         # it { should have_link("Profile",  href: user_path(user)) }
#         # it { should have_link("Settings", href: edit_user_path(user)) }
#         # it { should have_link("Log out",  href: logout_path) }
#         # it { should_not have_link("Log in",  href: login_path) }
#       end
#
#       context "followed by logout" do
#         # 同じサイトを 複数tab/window で開いている状態をシュミレート
#         # "Log out" をクリック １回目
#         context "by one browser tab/window" do
#           include_context "logout"
#         end
#         # "Log out" をクリック ２回目
#         context "by other browser tab/window" do
#           include_context "logout"
#         end
#       end
#
#       # # わから〜ん
#       # context "remember_me checkbox on" do
#       #   let(:user) { create(:user) }
#       #   let(:remember_digest) { User.digest('foobar') }
#       #
#       #   # クッキーを保存してログイン
#       #   before { log_in_as(user, remember_me: '1') }
#       #   # before { test_login user, remember_me: true, no_capybara: true }
#       #   # before { test_login user, remember_me: true, no_capybara: false }
#       #   # before { test_login user }
#       #
#       #   it { expect(user.remember_token).to be_present }
#       #
#       #   # # チェックボックスがチェックされているか判定
#       #   # it { expect(page).to have_checked_field("Remember me on this computer") }
#       #   # it { should have_checked_field("Remember me on this computer") }
#       #   # it "should be checked" do
#       #   #   checkbox = find("#session_remember_me")
#       #   #   expect(checkbox).to be_checked
#       #   # end
#       #
#       #   # specify { expect(remember_token).to eq user.remember_token }
#       #   # it { expect(response.cookies['remember_token']).to be_present }
#       #   # it { expect(remember_token).to be_present }
#       #   # it { expect(response.cookies['remember_token']).to eq user.remember_token }
#       # end
#
#     end
#   end
# end




# require 'rails_helper'
#
# RSpec.feature "UsersLogin", type: :feature do
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
#       it { should have_current_path(login_path)}
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
#       it { should have_current_path(user_path(user)) }
#       it { should have_title(user.name) }
#       it { should have_link("Users",    href: users_path) }
#       it { should have_link("Profile",  href: user_path(user)) }
#       it { should have_link("Settings", href: edit_user_path(user)) }
#       it { should have_link("Log out",  href: logout_path) }
#       it { should_not have_link("Log in",  href: login_path) }
#
#       context "followed by logout" do
#         # １回目のログアウト
#         context "logout by some browser tab/window" do
#           before { click_link "Log out" }
#           it { should_not have_link("Log out") }
#           it { should have_link("Log in") }
#           # 現在のページが特定のパスであることを検証
#           it { expect(current_path).to eq root_path }
#           it { should have_current_path(root_path)}
#         end
#         # ２回目のログアウト
#         context "logout by another browser tab/window" do
#           before { click_link "Log out" }
#           it { should_not have_link("Log out") }
#           it { should have_link("Log in") }
#
#           it { expect(current_path).to eq root_path }
#           it { should have_current_path(root_path)}
#         end
#
#         # ２回目のログアウト
#         # クリックできないので、deleteリクエストを送る
#         # before { click_link "Log out" }
#         # delete :destroy, params: { id: user.id }
#         # before { delete :destroy, params: {id: user.id} }
#
#         # before { visit current_path }
#         # before { delete logout_path }
#
#         # it { expect(current_path).to eq root_path }
#         # it { should have_current_path(root_path)}
#
#         # it "should not error" do
#         #   get :destroy
#         #   it { expect(response).to redirect_to(root_path) }
#         # end
#
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
# end
#
