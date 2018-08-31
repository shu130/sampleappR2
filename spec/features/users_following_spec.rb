require 'rails_helper'

RSpec.feature "UsersFollowing", type: :feature do

  include SupportModule
  include_context "setup"

  subject { page }

  # 未ログインの場合のテスト
  # authorization_spec.rb にて（別ファイル）

  describe "following" do
    before do
      login_as(user)
      users # => shared_context 内で定義 create_list(:other_user, 30)
      users.each { |u| user.follow(u) } # => 30人をフォロー
      user.follow(other_user) # => 自分が他人（1人）をフォロー
      # visit following_user_path(user)
      click_link "following"
    end
    # （セットアップの確認）
    it { expect(user.following.count).to eq 31 }
    it { expect(other_user.followers.count).to eq 1 }

    it { should have_title("Following") }
    it { should have_css('h3', text: "Following") }
    # it { should have_css('h1', text: user.name) }
    it_behaves_like "have user infomation"
    # it { should have_link(other_user.name, href: user_path(other_user)) }

    # ページネーション
    describe "pagination" do
      # before { users }
      # # （セットアップの確認）
      # it { expect(user.following.count).to eq 30 }
      # ページネーションでユーザが表示されること
      scenario "list each user" do
        # user = create(:user)
        # login_as(user)
        # click_link "following"
        should have_current_path(following_user_path(user))
        # should have_title("All users")
        # should have_css("h1", text: "All users")
        # title_heading("All users")
        # 30.times { create(:other_user) }
        user.following.paginate(page: 1).each do |user|
          expect(page).to have_css("li", text: user.name)
          expect(page).to have_link(user.name, href: user_path(user))
        end
      end
    end
  end
end

# # アウトライン
# # spec/features/users_following_spec.rb
#
#   describe "following"
#     # ユーザ情報のリンクが表示されていること
#     it_behaves_like "have user infomation"
#     # ページネーション
#     describe "pagination"
#       # フォロー中のユーザが表示されていること
#       scenario "list each following-users"
#
#

# require 'rails_helper'
#
# RSpec.feature "UsersFollowingFollowers", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   # 未ログインの場合 （before_action のテスト）
#   describe "login is necessary", type: :request do
#     describe "following" do
#       context "when non-login" do
#         subject { Proc.new { get following_user_path(user) } }
#         it_behaves_like "error flash", "Please log in"
#         it_behaves_like "redirect to path", "/login"
#       end
#     end
#     describe "followers" do
#       context "when non-login" do
#         subject { Proc.new { get followers_user_path(user) } }
#         it_behaves_like "error flash", "Please log in"
#         it_behaves_like "redirect to path", "/login"
#       end
#     end
#   end
#
#   describe "following/followers" do
#     before do
#       login_as(user)
#       user.follow(other_user)
#     end
#     describe "following" do
#       before { visit following_user_path(user) }
#       # before do
#       #   login_as(user)
#       #   visit following_user_path(user)
#       # end
#       it { should have_title("Following") }
#       it { should have_css('h1', text: user.name) }
#
#     end
#
#     describe "followers" do
#       before { visit followers_user_path(user) }
#     end
#   end
# end
