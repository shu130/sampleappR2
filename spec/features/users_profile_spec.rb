require 'rails_helper'

RSpec.feature "UsersProfile", type: :feature do

  include SupportModule
  include_context "setup"

  subject { page }

  describe "profile" do
    before { login_as(user) }
    # ページタイトルと見出しが正しいこと
    scenario "have title/heading" do
      # title_and_heading(user.name) # support_module
      should have_title(user.name)
      should have_css("h1", text: user.name)
    end
    # パスが正しいこと
    scenario "have correct path" do
      should have_current_path(user_path(user)) # or
      # expect(page).to have_current_path(user_path(user)) # or
      # expect(current_path).to eq user_path(user)
    end
    # 存在すべきリンクが表示されること
    it_behaves_like "have links of profile-page"

    # ユーザー情報
    describe "user-info" do
      before { my_posts }
      # （セットアップの確認）
      it { expect(user.microposts.count).to eq my_posts.count }
      it_behaves_like "have user profile infomation"
    end
    # マイクロポストの統計
    describe "micropost stats" do
      before do
        # user
        my_posts
        other_user
        other_posts
        user.follow(other_user)
        other_user.follow(user)
      end
      # （セットアップの確認）
      it { expect(user.microposts.count).to eq my_posts.count }
      it { expect(other_user.microposts.count).to eq other_posts.count }
      it_behaves_like "have link user's following/followers"
    end

    # マイクロポスト
    describe "microposts" do
      before { my_posts }
      # （セットアップの確認）
      it { expect(user.microposts.count).to eq my_posts.count }
      # it { should have_current_path(user_path(user)) }
      # it { expect(current_path).to eq user_path(user) }

      # マイクロポストが表示されていること
      scenario "pagination list each micropost" do
        # should have_css("h3", text: "Microposts")
        # should have_text("Microposts")
        # should have_text("#{user.microposts.count}")
        # should have_css("h3", text: "Micropost (#{user.microposts.count})")
        expect {
          # Micropost.paginate(page: 1).each do |post|
          user.microposts.paginate(page: 1).each do |post|
            should have_link("img.gravatar", href: post.user)
            should have_link("#{micropost.user.name}", href: post.user)
            should have_css("li#micropost-#{post.id}", text: post.content)
          end
          # user.microposts.paginate(page: 1).each do |post|
          #   have_link("img.gravatar", href: micropost.user)
          #   have_link("#{micropost.user.name}", href: micropost.user)
          #   have_css("li#micropost-#{post.id}", text: post.content)
          # end
        }
      end
    end

    # フォロー／フォロー解除 ボタン
    # describe "follow/unfollow buttons", js: true do
    describe "follow/unfollow buttons" do
      # フォローしたい相手のパスに移動
      before { visit user_path(other_user) }
      # フォロー
      context "following other-user" do
        # suject を定義
        subject { click_button "Follow" }
        # （自分にとって）following が 1 増加すること (increment: 1)
        scenario "following increment 1 (for user)" do
          expect { subject }.to change(user.following, :count).by(1)
        end
        # （相手にとって）follower が 1 増加すること (increment: 1)
        scenario "followers increment 1 (for other-user)" do
          expect { subject }.to change(other_user.followers, :count).by(1)
        end
        # ボタンが Unfollow に変わる
        scenario "toggle 'Unfollow'" do
          expect {
            subject
            expect(page).to have_css "div#follow_form", text: "Unfollow"
          }
        end
      end
      # フォロー解除
      context "unfollow other-user" do
        # other_user をフォロー
        before { click_button "Follow" }
        # suject を定義
        subject { click_button "Unfollow" }

        scenario "following decrement -1 (for user)" do
          expect { subject }.to change(user.following, :count).by(-1)
        end
        scenario "followers decrement -1 (for other-user)" do
          expect { subject }.to change(other_user.followers, :count).by(-1)
        end
        # ボタンが Follow に変わる
        scenario "toggle 'Follow'" do
          expect {
            subject
            expect(page).to have_css("div#follow_form", text: "Follow")
          }
        end
      end
    end
  end
end






# require 'rails_helper'
#
# RSpec.feature "UsersProfile", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   describe "profile" do
#     before { login_as(user) }
#     # ページタイトルと見出しが正しいこと
#     scenario "have title/heading" do
#       # title_and_heading(user.name) # support_module
#       should have_title(user.name)
#       should have_css("h1", text: user.name)
#     end
#     # パスが正しいこと
#     scenario "have correct path" do
#       should have_current_path(user_path(user)) # or
#       # expect(page).to have_current_path(user_path(user))
#       expect(current_path).to eq user_path(user)
#     end
#     # 存在すべきリンクが表示されること
#     it_behaves_like "have links of profile-page"
#
#     # ユーザー情報
#     describe "user-info" do
#       before { my_posts }
#       # （セットアップの確認）
#       it { expect(user.microposts.count).to eq my_posts.count }
#       it_behaves_like "have user profile infomation"
#     end
#     # マイクロポストの統計
#     describe "micropost stats" do
#       before do
#         # user
#         my_posts
#         other_user
#         other_posts
#         user.follow(other_user)
#         other_user.follow(user)
#       end
#       # （セットアップの確認）
#       it { expect(user.microposts.count).to eq my_posts.count }
#       it { expect(other_user.microposts.count).to eq other_posts.count }
#       it_behaves_like "have link user's following/followers"
#     end
#
#     # マイクロポスト
#     describe "microposts" do
#       before { my_posts }
#       # （セットアップの確認）
#       it { expect(user.microposts.count).to eq my_posts.count }
#       # it { should have_current_path(user_path(user)) }
#       # it { expect(current_path).to eq user_path(user) }
#
#       # マイクロポストが表示されていること
#       scenario "pagination list each micropost" do
#         # should have_css("h3", text: "Microposts")
#         # should have_text("Microposts")
#         # should have_text("#{user.microposts.count}")
#         # should have_css("h3", text: "Micropost (#{user.microposts.count})")
#         expect {
#           # Micropost.paginate(page: 1).each do |post|
#           user.microposts.paginate(page: 1).each do |post|
#             should have_link("img.gravatar", href: post.user)
#             should have_link("#{micropost.user.name}", href: post.user)
#             should have_css("li#micropost-#{post.id}", text: post.content)
#           end
#           # user.microposts.paginate(page: 1).each do |post|
#           #   have_link("img.gravatar", href: micropost.user)
#           #   have_link("#{micropost.user.name}", href: micropost.user)
#           #   have_css("li#micropost-#{post.id}", text: post.content)
#           # end
#         }
#       end
#     end
#
#     # フォロー／フォロー解除 ボタン
#     # describe "follow/unfollow buttons", js: true do
#     describe "follow/unfollow buttons" do
#       # フォローしたい相手のパスに移動
#       before { visit user_path(other_user) }
#       # フォロー
#       context "following other-user" do
#         # suject を定義
#         subject { click_button "Follow" }
#         # （自分にとって）following が 1 増加すること (increment: 1)
#         scenario "following increment 1 (for user)" do
#           expect { subject }.to change(user.following, :count).by(1)
#         end
#         # （相手にとって）follower が 1 増加すること (increment: 1)
#         scenario "followers increment 1 (for other-user)" do
#           expect { subject }.to change(other_user.followers, :count).by(1)
#         end
#         # ボタンが Unfollow に変わる
#         scenario "toggle 'Unfollow'" do
#           expect {
#             subject
#             expect(page).to have_css "div#follow_form", text: "Unfollow"
#           }
#         end
#       end
#       # フォロー解除
#       context "unfollow other-user" do
#         # other_user をフォロー
#         before { click_button "Follow" }
#         # suject を定義
#         subject { click_button "Unfollow" }
#
#         scenario "following decrement -1 (for user)" do
#           expect { subject }.to change(user.following, :count).by(-1)
#         end
#         scenario "followers decrement -1 (for other-user)" do
#           expect { subject }.to change(other_user.followers, :count).by(-1)
#         end
#         # ボタンが Follow に変わる
#         scenario "toggle 'Follow'" do
#           expect {
#             subject
#             expect(page).to have_css("div#follow_form", text: "Follow")
#           }
#         end
#       end
#     end
#   end
# end



# # アウトライン
# # spec/features/users_profile_spec.rb
#
# RSpec.feature "UsersProfile", type: :feature do
#
#   describe "profile"
#     # ページタイトルと見出しが正しいこと
#     scenario "have title/heading"
#     # 存在すべきリンクが表示されること
#     it_behaves_like "have links of profile-page"
#     # パスが正しいこと
#     scenario "have correct path"
#
#     # ユーザー情報
#     describe "user-info"
#       it_behaves_like "have user profile infomation"
#     # マイクロポストの統計
#     describe "micropost stats"
#       it_behaves_like "have link user's following/followers"
#
#     # マイクロポスト
#     describe "microposts"
#       # マイクロポストが表示されていること
#       scenario "pagination list each micropost"
#
#     # フォロー／フォロー解除 ボタン
#     describe "follow/unfollow buttons"
#       # フォロー
#       context "following other-user"
#         # （自分にとって）following が 1 増加すること (increment: 1)
#         scenario "following increment 1 (for user)"
#         # （相手にとって）follower が 1 増加すること (increment: 1)
#         scenario "followers increment 1 (for other-user)"
#         # ボタンが Unfollow に変わる
#         scenario "toggle 'Unfollow'"
#       # フォロー解除
#       context "unfollow other-user"
#         # （自分にとって）following が 1 減少すること (decrement: -1)
#         scenario "following decrement -1 (for user)"
#         # （相手にとって）follower が 1 減少すること (decrement: -1)
#         scenario "followers decrement -1 (for other-user)"
#         # ボタンが Follow に変わる
#         scenario "toggle 'Follow'"
# end




# require 'rails_helper'
#
# RSpec.feature "UsersProfile", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   describe "profile" do
#     before { login_as(user) }
#     # ページタイトルと見出しが正しいこと
#     scenario "have title/heading" do
#       # title_and_heading(user.name) # support_module
#       should have_title(user.name)
#       should have_css("h1", text: user.name)
#     end
#     # パスが正しいこと
#     scenario "have correct path" do
#       should have_current_path(user_path(user)) # or
#       # expect(page).to have_current_path(user_path(user))
#       expect(current_path).to eq user_path(user)
#     end
#     # 存在すべきリンクが表示されること
#     it_behaves_like "have links of profile-page"
#
#     # ユーザー情報
#     describe "user-info" do
#       before { my_posts }
#       # （セットアップの確認）
#       it { expect(user.microposts.count).to eq my_posts.count }
#       it_behaves_like "have user profile infomation"
#     end
#     # # マイクロポストの統計
#     # describe "micropost stats" do
#     #   before do
#     #     # user
#     #     my_posts
#     #     other_user
#     #     other_posts
#     #     user.follow(other_user)
#     #     other_user.follow(user)
#     #   end
#     #   # （セットアップの確認）
#     #   it { expect(user.microposts.count).to eq my_posts.count }
#     #   it { expect(other_user.microposts.count).to eq other_posts.count }
#     #   it_behaves_like "have link user's following/followers"
#     # end
#
#     # マイクロポスト
#     describe "microposts" do
#       before { my_posts }
#       # （セットアップの確認）
#       it { expect(user.microposts.count).to eq my_posts.count }
#       # マイクロポストが表示されていること
#       scenario "pagination list each micropost" do
#         # should have_css("h3", text: "Microposts")
#         # should have_text("Microposts")
#         # should have_text("#{user.microposts.count}")
#         # should have_css("h3", text: "Micropost (#{user.microposts.count})")
#         expect {
#           # Micropost.paginate(page: 1).each do |post|
#           user.microposts.paginate(page: 1).each do |post|
#             have_link("img.gravatar", href: micropost.user)
#             have_link("#{micropost.user.name}", href: micropost.user)
#             have_css("li#micropost-#{post.id}", text: post.content)
#           end
#         }
#       end
#     end
#
#     # フォロー／フォロー解除 ボタン
#     # describe "follow/unfollow buttons", js: true do
#     describe "follow/unfollow buttons" do
#       # フォローしたい相手のパスに移動
#       before { visit user_path(other_user) }
#       # フォロー
#       context "following other-user" do
#         # （自分にとって）following が 1 増加すること (increment: 1)
#         scenario "following increment 1 (for user)" do
#           expect {
#             # visit user_path(other_user)
#             click_button "Follow"
#           }.to change(user.following, :count).by(1)
#         end
#         # （相手にとって）follower が 1 増加すること (increment: 1)
#         scenario "followers increment 1 (for other-user)" do
#           expect {
#             click_button "Follow"
#           }.to change(other_user.followers, :count).by(1)
#         end
#         # ボタンが Unfollow に変わる
#         scenario "toggle 'Unfollow'" do
#           expect {
#             click_button "Follow"
#             expect(page).to have_css "div#follow_form", text: "Unfollow"
#           }
#         end
#       end
#       # フォロー解除
#       context "unfollow other-user" do
#         # before { user.follow(other_user) }
#         before do
#           user.follow(other_user)
#           visit user_path(other_user)
#         end
#         scenario "following decrement -1 (for user)" do
#           expect {
#             click_button "Unfollow"
#           }.to change(user.following, :count).by(-1)
#         end
#         scenario "followers decrement -1 (for other-user)" do
#           expect {
#             click_button "Unfollow"
#           }.to change(other_user.followers, :count).by(-1)
#         end
#         # ボタンが Follow に変わる
#         scenario "toggle 'Follow'" do
#           expect {
#             click_button "Unfollow"
#             expect(page).to have_css("div#follow_form", text: "Follow")
#           }
#         end
#       end
#     end
#   end
# end





# require 'rails_helper'
#
# RSpec.feature "UsersProfile", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   describe "profile" do
#     before { login_as(user) }
#     # ページタイトルと見出しが正しいこと
#     scenario "have title/heading" do
#       title_heading_of_profile_page(user) # support_module
#     end
#     # パスが正しいこと
#     scenario "have correct path" do
#       should have_current_path(user_path(user)) # or
#       # expect(page).to have_current_path(user_path(user))
#     end
#     # 存在すべきリンクが表示されること
#     scenario "have links" do
#       links_of_profile_page(user)
#     end
#     # マイクロポスト
#     describe "microposts" do
#       # マイクロポストが表示されていること
#       scenario "pagination list each micropost" do
#         expect {
#           Micropost.paginate(page: 1).each do |post|
#             have_css("h1", text: user.name)
#             have_css("li#micropost-#{post.id}", text: post.content)
#             have_css("span", text: user.microposts.count)
#           end
#         }
#       end
#     end
#
#     # フォロー／フォロー解除 ボタン
#     # describe "follow/unfollow buttons", js: true do
#     describe "follow/unfollow buttons" do
#       # フォローしたい相手のパスに移動
#       before { visit user_path(other_user) }
#       # フォロー
#       context "following other-user" do
#         # （自分にとって）following が 1 増加すること (increment: 1)
#         scenario "following increment 1 (for user)" do
#           expect {
#             # visit user_path(other_user)
#             click_button "Follow"
#           }.to change(user.following, :count).by(1)
#         end
#         # （相手にとって）follower が 1 増加すること (increment: 1)
#         scenario "followers increment 1 (for other-user)" do
#           expect {
#             click_button "Follow"
#           }.to change(other_user.followers, :count).by(1)
#         end
#         # ボタンが Unfollow に変わる
#         scenario "toggle 'Unfollow'" do
#           expect {
#             click_button "Follow"
#             expect(page).to have_css "div#follow_form", text: "Unfollow"
#           }
#         end
#       end
#       # フォロー解除
#       context "unfollow other-user" do
#         # before { user.follow(other_user) }
#         before do
#           user.follow(other_user)
#           visit user_path(other_user)
#         end
#         scenario "following decrement -1 (for user)" do
#           expect {
#             click_button "Unfollow"
#           }.to change(user.following, :count).by(-1)
#         end
#         scenario "followers decrement -1 (for other-user)" do
#           expect {
#             click_button "Unfollow"
#           }.to change(other_user.followers, :count).by(-1)
#         end
#         # ボタンが Follow に変わる
#         scenario "toggle 'Follow'" do
#           expect {
#             click_button "Unfollow"
#             expect(page).to have_css "div#follow_form", text: "Follow"
#           }
#         end
#       end
#     end
#   end
# end


# # アウトライン
#
#   describe "profile"
#     # ページタイトルと見出しが正しいこと
#     scenario "have title/heading"
#     # パスが正しいこと
#     scenario "have correct path"
#     # 存在すべきリンクが表示されること
#     scenario "have links"
#     # マイクロポスト
#     describe "microposts"
#       # マイクロポストが表示されていること
#       scenario "pagination list each micropost"
#
#     # フォロー／フォロー解除 ボタン
#     describe "follow/unfollow buttons"
#       # フォロー
#       context "following other-user"
#         # （自分にとって）following が 1 増加すること (increment: 1)
#         scenario "following increment 1 (for user)"
#         # （相手にとって）follower が 1 増加すること (increment: 1)
#         scenario "followers increment 1 (for other-user)"
#         # ボタンが Unfollow に変わる
#         scenario "toggle 'Unfollow'"
#       # フォロー解除
#       context "unfollow other-user"
#         # （自分にとって）following が 1 減少すること (decrement: -1)
#         scenario "following decrement -1 (for user)"
#         # （相手にとって）follower が 1 減少すること (decrement: -1)
#         scenario "followers decrement -1 (for other-user)"
#         # ボタンが Follow に変わる
#         scenario "toggle 'Follow'"



# # アウトライン
#
#   describe "profile"
#
#     ページタイトルと見出しが正しいこと
#     パスが正しいこと
#     存在すべきリンクが表示されること
#
#     マイクロポスト
#       マイクロポストが表示されていること
#
#     フォロー／フォロー解除 ボタン
#       フォロー
#         （自分にとって）following が 1 増加すること (increment: 1)
#         （相手にとって）follower が 1 増加すること (increment: 1)
#         ボタンが Unfollow に変わる
#       フォロー解除
#         （自分にとって）following が 1 減少すること (decrement: -1)
#         （相手にとって）follower が 1 減少すること (decrement: -1)
#         ボタンが Follow に変わる


# require 'rails_helper'
#
# RSpec.feature "UsersProfile", type: :feature do
#
#   subject { page }
#
#   describe "profile" do
#     let(:user) { create(:user) }
#     before { visit user_path(user) }
#     it { should have_title(user.name) }
#     it { should have_content(user.name) }
#
#     # なぜかNG
#     # it_behaves_like "have user title, heading"
#     # it_behaves_like "links in profile-page"
#   end
# end
