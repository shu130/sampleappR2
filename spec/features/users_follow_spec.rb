require 'rails_helper'

RSpec.feature "UsersFollow", type: :feature do

  include SupportModule
  include_context "setup"

  subject { page }

  # 未ログインの場合のテスト
  # authorization_spec.rb にて（別ファイル）

  describe "following/followers method" do
    before do
      users # => shared_context 内で定義 create_list(:other_user, 30)
      users.each do |u|
         user.follow(u) # => 自分が ３０人をフォローする
         u.follow(user) # => 他人の ３０人にフォローされる
      end
      user.follow(other_user) # => 自分が他人（1人）をフォロー
      other_user.follow(user) # => 他人が自分（1人）をフォロー
    end

    # （セットアップの確認：３１人をフォローしている）
    it { expect(user.following.count).to eq 31 }
    # （セットアップの確認：３１人にフォローされている）
    it { expect(other_user.following.count).to eq 1 }
    it { expect(user.followers.count).to eq 31 }

    describe "following page" do
      before do
        login_as(user)
        click_link "following"
      end
      it_behaves_like "have user infomation"
    end
    describe "followers page" do
      before do
        login_as(user)
        click_link "following"
      end
      it_behaves_like "have user infomation"
    end

    describe "pagination" do
      before { login_as(user) }
      scenario "list each following" do
        # login_as(user)
        click_link "following"
        user.following.paginate(page: 1).each do |u|
          expect(page).to have_css("li", text: u.name)
          expect(page).to have_link(u.name, href: user_path(u))
        end
      end
      scenario "list each followers" do
        # login_as(user)
        click_link "followers"
        user.followers.paginate(page: 1).each do |u|
          expect(page).to have_css("li", text: u.name)
          expect(page).to have_link(u.name, href: user_path(u))
        end
      end
    end
  end
end

# ## アウトライン
#
#   # フォロー／フォロワー
#   describe "following/followers method"
#     # 自分がフォロー中のユーザのページ
#     describe "following page"
#       # ユーザ情報の表示が正しいこと
#       it_behaves_like "have user infomation"
#     # 自分をフォローしているユーザのページ
#     describe "followers page"
#       # ユーザ情報の表示が正しいこと
#       it_behaves_like "have user infomation"
#     # ページネーション
#     describe "pagination"
#       # ユーザ情報が表示されている
#       scenario "list each following"
#       # ユーザ情報が表示されている
#       scenario "list each followers"
