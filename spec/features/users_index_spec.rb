require 'rails_helper'

RSpec.feature "UsersIndex", type: :feature do
  include LoginSupport
  subject { page }

  # リスト 10.48: ページネーションを含めたUsersIndexのテスト
  # ページネーションでユーザが表示されること
  describe "index" do
    scenario "pagination list each user" do
      user = create(:user)
      login_as(user)
      # before { visit users_path }
      click_link "Users"
      30.times { create(:other_user) }
      User.paginate(page: 1).each do |user|
        expect(page).to have_css("li", text: user.name)
      end
    end

    context "admin-user" do
      scenario "delete user (increment: -1)" do
        admin_user = create(:admin)
        login_as(admin_user)
        click_link "Users"
        expect {
          should have_link('delete', href: user_path(User.first))
          should have_link('delete', href: user_path(User.second))
          should_not have_link('delete', href: user_path(admin_user))
          expect {
            click_link('delete', match: :first)
          }.to change(User, :count).by(-1)
        }
      end
    end

    context "non-addmin-user" do
      scenario "not allow delete user (increment: 0)" do
        user = create(:user)
        login_as(user)
        click_link "Users"
        expect {
          should_not have_link('delete', href: user_path(User.first))
          should_not have_link('delete', href: user_path(User.second))
          should_not have_link('delete', href: user_path(user))
          expect {
            click_link('delete', match: :first)
          }.to change(User, :count).by(0)
        }
      end
    end
  end
end


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
