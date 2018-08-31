require 'rails_helper'

RSpec.feature "UsersFollowers", type: :feature do

  include SupportModule
  include_context "setup"

  subject { page }

  # 未ログインの場合のテスト
  # authorization_spec.rb にて（別ファイル）

  describe "followers" do
    before do
      login_as(other_user) # => 他人がログイン
      users # => shared_context 内で定義 create_list(:other_user, 30)
      other_user.follow(user) # => 他人が自分（1人）をフォロー
      users.each { |u| other_user.follow(u) } # => 30人をフォロー
      # user.follow(other_user)
      # visit followers_user_path(user)
      click_link "followers"
    end
    # （セットアップの確認）
    it { expect(other_user.following.count).to eq 31 }
    it { expect(user.followers.count).to eq 1 }

    it { should have_title("Followers") }
    it_behaves_like "have user infomation"
    it { should have_css('h3', text: "Followers") }
    # it { should have_css('h1', text: user.name) }
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
        should have_current_path(followers_user_path(othere_user))
        # should have_title("All users")
        # should have_css("h1", text: "All users")
        # title_heading("All users")
        # 30.times { create(:other_user) }
        user.followers.paginate(page: 1).each do |user|
          expect(page).to have_css("li", text: user.name)
          expect(page).to have_link(user.name, href: user_path(user))
        end
      end
    end
  end
end

# # アウトライン
# # spec/features/users_followers_spec.rb


# end
