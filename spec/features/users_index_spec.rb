require 'rails_helper'

RSpec.feature "UsersIndex", type: :feature do

  include SupportModule
  include_context "setup"

  subject { page }

  describe "index", type: :request do
    # 未ログインの場合 （before_action のテスト）
    describe "login is necessary" do
      context "non-login" do
        subject { Proc.new { get users_path } }
        it_behaves_like "error message", "Please log in"
        it_behaves_like "redirect to path", "/login"
      end
    end
    # ページネーション
    describe "pagination" do
      # ページネーションでユーザが表示されること
      scenario "list each user" do
        # user = create(:user)
        login_as(user)
        click_link "Users"
        current_path(users_path)
        should have_title("All users")
        should have_css("h1", text: "All users")
        # title_heading("All users")
        # 30.times { create(:other_user) }
        User.paginate(page: 1).each do |user|
          expect(page).to have_css("li", text: user.name)
        end
      end
    end

    # 管理者ユーザ(admin)権限
    describe "authorization of delete user" do
      context "admin-user" do
        # adminユーザはユーザの削除ができること
        scenario "success delete (decrement: -1)" do
          # admin_user = create(:admin)
          login_as(admin)
          click_link "Users"
          current_path(users_path)
          expect {
            have_link('delete', href: user_path(User.first))
            have_link('delete', href: user_path(User.second))
            not have_link('delete', href: user_path(admin))
            click_link('delete', match: :first)
          }.to change(User, :count).by(-1)
        end
      end
      # 非管理者ユーザ
      # 一般ユーザはユーザの削除ができないこと
      context "non-addmin-user" do
        scenario "fail delete (decrement: 0)" do
          # user = create(:user)
          login_as(user)
          click_link "Users"
          current_path(users_path)
          expect {
            not have_link('delete', href: user_path(User.first))
            not have_link('delete', href: user_path(User.second))
            # not have_link('delete', href: user_path(user))
            # click_link('delete', match: :first)
          }.to change(User, :count).by(0)
        end
      end
    end
  end
end


# # アウトライン
#
#   describe "index"
#     # 未ログインの場合 （before_action のテスト）
#     describe "login is necessary"
#       context "non-login"
#         it_behaves_like "error message", "Please log in" # エラー
#         it_behaves_like "redirect to path", "/login" # リダイレクト
#     # ページネーション
#     describe "pagination"
#       # ページネーションでユーザが表示されること
#       scenario "list each user"
#
#     # 管理者ユーザ(admin)権限
#     describe "authorization of delete user"
#       # 管理者ユーザ(admin)
#       context "admin-user"
#         # ユーザの削除ができること
#         scenario "success delete (decrement: -1)"
#       # 非管理者ユーザ
#       context "non-addmin-user"
#         # 一般ユーザはユーザの削除ができないこと
#         scenario "fail delete (decrement: 0)"





# require 'rails_helper'
#
# RSpec.feature "UsersIndex", type: :feature do
#
#   subject { page }
#
#   describe "index" do
#     include_context "user login"
#     before { visit users_path }
#     it_behaves_like "title, heading", "All users", "All users"
#
#     describe "pagination" do
#       before(:all) { users = 30.times { create(:other_user) } }
#       # after(:all) { User.delete_all }
#       # after(:all) { other_user.destroy }
#       it { should have_selector('div.pagination') }
#       it "should list each user" do
#         User.paginate(page: 1).each do |user|
#           expect(page).to have_selector('li', text: user.name)
#         end
#       end
#     end
#
#     describe "delete links" do
#       context "as non-admin-user" do
#         # it_behaves_like "not have link", "delete", user_path(user)
#         # it { should_not have_link('delete') } # or
#         it { should_not have_link('delete', href: user_path(user)) }
#       end
#
#       context "as admin-user" do
#         include_context "admin-user login"
#         before { visit users_path }
#         it { should have_link('delete', href: user_path(User.first)) }
#         it { should_not have_link('delete', href: user_path(admin)) }
#         it "delete another user (increment:-1)" do
#           expect do
#             click_link('delete', match: :first)
#           end.to change(User, :count).by(-1)
#         end
#       end
#     end
#   end
# end





# # Tips
# before(:all)で作成されたデータは、テストが終わった後もロールバックされず、データベースに残ってしまう。なので、before(:all)でデータを作成した後は、after(:all)でデータベースをきれいにする必要がある。
# https://relishapp.com/rspec/rspec-rails/docs/transactions


# bkup
# require 'rails_helper'
#
# RSpec.feature "UsersIndex", type: :feature do
#
#   subject { page }
#
#   describe "index" do
#     let(:user) { create(:user) }
#     before(:each) do
#       test_login user
#       visit users_path
#     end
#     it { should have_current_path("/users") }
#     it { should have_title('All users') }
#     it { should have_content('All users') }
#     # or
#     it { should have_selector 'h1', text: 'All users' }
#
#     describe "pagination" do
#       before(:all) { 30.times { create(:sequence_user) } }
#       after(:all) { User.delete_all }
#       it { should have_selector('div.pagination') }
#       it "should list each user" do
#         User.paginate(page: 1).each do |user|
#           expect(page).to have_selector('li', text: user.name)
#         end
#       end
#     end
#
#     describe "delete links" do
#       context "as non-admin-user" do
#         it { should_not have_link('delete') }
#         # or
#         it { should_not have_link('delete', href: user_path(user)) }
#       end
#
#       context "as admin-user" do
#         let(:admin) { create(:admin_user) }
#         before do
#           test_login admin_user
#           visit users_path
#         end
#         it { should have_link('delete', href: user_path(User.first)) }
#         it "should be able to delete another user" do
#           expect do
#             click_link('delete', match: :first)
#           end.to change(User, :count).by(-1)
#         end
#         it { should_not have_link('delete', href: user_path(admin_user)) }
#       end
#     end
#   end
# end
