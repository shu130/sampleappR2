require 'rails_helper'

RSpec.feature "TopPages", type: :feature do

  include SupportModule
  include_context "setup"

  subject { page }

  describe "Home" do
    # 未ログイン時
    context "when non-login" do
      before { visit root_path }
      it { should have_css('h1', text: 'Sample App') }
      it { should have_title(full_title "") }
      it { should_not have_title(full_title "Home") }
    end
    # ログイン時
    context "when login" do
      before do
        login_as(user)
        visit root_path
        # my_posts
      end
      # ユーザー情報
      describe "user-info" do
        before { my_posts }
        # （セットアップの確認）
        it { expect(user.microposts.count).to eq my_posts.count }
        it_behaves_like "have user infomation"
      end
      # マイクロポストの統計
      describe "micropost stats" do
        before do
          user.follow(other_user)
          other_user.follow(user)
        end
        it_behaves_like "have link user's following/followers"
      end
      # マイクロポスト
      describe "micropost" do
        # フォームが正しいこと
        it_behaves_like "micropost-form have right css"
        # マイクロポストの投稿／削除
          # micropost_pages_spec.rb にて（別ファイル）作成
        # フィード
        describe "feed", type: :request do
        # describe "feed" do
          # （セットアップ）
          let(:following) { create_list(:other_user, 30) }
          # 関連付けされるファクトリをを明示的に指定
          before do
            # 自分が１０つのマイクロポストを保持
            create_list(:user_post, 10, user: user)
            following.each do |u|
               user.follow(u) # => 自分が ３０人をフォローする
               u.follow(user) # => 他人の ３０人にフォローされる
               create_list(:other_user_post, 3, user: u)
               # => ３０人それぞれが、３つずつマイクロポストを保持
            end
          end
          # （セットアップの確認）
          it { expect(user.microposts.count).to eq 10 }
          # マイクロポストの合計が１００
          it { expect(Micropost.all.count).to eq 100 }

          scenario "render the micropost feed" do
            should have_current_path("/")
            # ここで失敗する
            user.feed.each do |post|
            # user.feed.paginate(page: 1).each do |post|
              # expect(page).to have_link("img.gravatar", href: post.user)
              expect(page).to have_content("#{post.content}")
              # should have_link("img.gravatar", href: post.user)
              # should have_link("#{post.user.name}", href: post.user)
              # should have_text("#{post.user.name}")
              # should have_link("#{post.user.name}", href: post.user)
              # should have_css("li#micropost", text: post.content)
              # should have_css("li#micropost-#{post.id}", text: post.content)
            end
          end
        end
      end
    end
  end

  describe "Help" do
    before { visit help_path }
    it { should have_css('h1', text: 'Help') }
    it { should have_title(full_title "Help") }
  end

  describe "About" do
    before { visit about_path }
    it { should have_css('h1', text: 'About Us') }
    it { should have_title(full_title "About") }
  end

  describe "Contact" do
    before { visit contact_path }
    it { should have_css('h1', text: 'Contact') }
    it { should have_title(full_title "Contact") }
  end
end


# require 'rails_helper'
#
# RSpec.feature "TopPages", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   describe "Home" do
#     # 未ログイン時
#     context "when non-login" do
#       before { visit root_path }
#       it { should have_css('h1', text: 'Sample App') }
#       it { should have_title(full_title "") }
#       it { should_not have_title(full_title "Home") }
#     end
#     # ログイン時
#     context "when login" do
#       before do
#         login_as(user)
#         visit root_path
#         # my_posts
#       end
#       # ユーザー情報
#       describe "user-info" do
#         before { my_posts }
#         # （セットアップの確認）
#         it { expect(user.microposts.count).to eq my_posts.count }
#         it_behaves_like "have user infomation"
#       end
#       # マイクロポストの統計
#       describe "micropost stats" do
#         before do
#           user.follow(other_user)
#           other_user.follow(user)
#         end
#         it_behaves_like "have link user's following/followers"
#       end
#       # マイクロポスト
#       describe "micropost" do
#         # フォームが正しいこと
#         it_behaves_like "micropost-form have right css"
#         # マイクロポストの投稿／削除
#           # micropost_pages_spec.rb にて（別ファイル）作成
#         # フィード
#         describe "feed" do
#           scenario "render the micropost feed" do
#             user.feed.each do |item|
#               expect(page).to have_css("ol.microposts")
#               expect(page).to have_css("span.content")
#             end
#           end
#         end
#       end
#     end
#   end
#
#   describe "Help" do
#     before { visit help_path }
#     it { should have_css('h1', text: 'Help') }
#     it { should have_title(full_title "Help") }
#   end
#
#   describe "About" do
#     before { visit about_path }
#     it { should have_css('h1', text: 'About Us') }
#     it { should have_title(full_title "About") }
#   end
#
#   describe "Contact" do
#     before { visit contact_path }
#     it { should have_css('h1', text: 'Contact') }
#     it { should have_title(full_title "Contact") }
#   end
# end



# # アウトライン
# # spec/features/top_pages_spec.rb
#
# RSpec.feature "TopPages", type: :feature do
#   describe "Home"
#     # 未ログイン時
#     context "when non-login"
#       # タイトルが正しいこと
#       # 見出しが正しいこと
#     # ログイン時
#     context "when login"
#       # ユーザー情報
#       describe "user-info"
#         it_behaves_like "have user infomation"
#         # マイクロポストの統計
#         describe "micropost stats"
#           it_behaves_like "have link user's following/followers"
#       # マイクロポスト
#       describe "micropost"
#         # フォームが正しいこと
#         it_behaves_like "micropost-form have right css"
#         # マイクロポストの投稿／削除
#           # micropost_pages_spec.rb にて（別ファイル）作成
#         describe "feed"
#           scenario "render the micropost feed"
#
#   describe "Help"
#       # タイトルが正しいこと
#       # 見出しが正しいこと
#   describe "About"
#       # タイトルが正しいこと
#       # 見出しが正しいこと
#   describe "Contact"
#       # タイトルが正しいこと
#       # 見出しが正しいこと
# end



# # アウトライン
#
# RSpec.feature "TopPages", type: :feature do
#   describe "Home"
#     未ログイン時
#       title, heading が正しいこと
#     ログイン時
#       ユーザー情報
#         gravatar があること
#         名前があること
#         マイクロポスト投稿数があること
#         プロフィールへのリンクがあること
#       統計情報
#         following数の表示とリンクがあること
#         follower数の表示とリンクがあること
#       マイクロポスト
#         フォームが正しいこと
#         フィード
# end


# require 'rails_helper'
# # require 'rspec/its'
#
# RSpec.feature "TopPages", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   describe "Home" do
#     # 未ログイン時
#     context "when non-login" do
#       before { visit root_path }
#       it { should have_css('h1', text: 'Sample App') }
#       it { should have_title(full_title "") }
#       it { should_not have_title(full_title "Home") }
#     end
#     # ログイン時
#     context "when login" do
#       # let(:user) { create(:user) }
#       # before { login_as(user) }
#       before do
#         login_as(user)
#         other_user.follow(user)
#         visit root_path
#       end
#       # ユーザー情報
#       describe "user-info" do
#         scenario "have user infomation" do
#           should have_css('img.gravatar')
#           should have_css('h1', text: user.name)
#           should have_css('span', text: user.microposts.count)
#           should have_link("view my profile", href: user_path(user))
#         end
#       end
#       # 統計
#       describe "stats" do
#         scenario "have link user's following/followers" do
#           should have_link("#{user.following.count}following", href: following_user_path(user))
#           should have_link("#{user.followers.count}followers", href: followers_user_path(user))
#           # should have_css("strong#following.stat", text: user.following.count)
#           # should have_css("strong#followers.stat", text: user.followers.count)
#         end
#       end
#       # マイクロポスト
#       describe "micropost" do
#         # フォームが正しいこと
#         scenario "form is correct" do
#           # micropost_form_css  # support_module
#           should have_css('textarea#micropost_content')
#           should have_css('input#micropost_picture')
#           should have_button('Post')
#         end
#         # フィード
#         describe "feed" do
#           scenario "render the micropost feed" do
#             user.feed.each do |item|
#               expect(page).to have_css("ol.microposts")
#               expect(page).to have_css("span.content")
#               # expect(page).to have_css("span.content", text: item.content)
#               # expect(page).to have_content("#{item.content}")
#               # should have_selector("li#micropost-#{item.id}", text: item.content)
#               # should have_content("#{item.content}")
#               # should have_css("li#micropost-#{item.id}")
#             end
#           end
#         end
#       end
#     end
#   end
#
#   describe "Help" do
#     before { visit help_path }
#     it { should have_css('h1', text: 'Help') }
#     it { should have_title(full_title "Help") }
#   end
#
#   describe "About" do
#     before { visit about_path }
#     it { should have_css('h1', text: 'About Us') }
#     it { should have_title(full_title "About") }
#   end
#
#   describe "Contact" do
#     before { visit contact_path }
#     it { should have_css('h1', text: 'Contact') }
#     it { should have_title(full_title "Contact") }
#   end
#
# end


# アウトライン
  # describe "Home"
    # 未ログイン時
      # title, heading が正しいこと
    # ログイン時
      # ユーザー情報
        # gravatar があること
        # 名前があること
        # マイクロポスト投稿数があること
        # プロフィールへのリンクがあること
      # 統計情報
        # following数の表示とリンクがあること
        # follower数の表示とリンクがあること
      # マイクロポスト
        # フォームが正しいこと
        # フィード


# RSpec.feature "TopPages", type: :feature do
#
#   let(:base_title) { "Ruby on Rails Tutorial Sample App" }
#
#   scenario "Home" do
#     visit root_path
#     expect(page).to have_content('Sample App')
#     expect(page).to have_title("Home | #{base_title}")
#   end
#
#   scenario "Help" do
#     visit help_path
#     expect(page).to have_content('Help')
#     expect(page).to have_title("Help | #{base_title}")
#   end
#
#   scenario "About" do
#     visit about_path
#     expect(page).to have_content('About Us')
#     expect(page).to have_title("About | #{base_title}")
#   end
#
#   scenario "Contact" do
#     visit contact_path
#     expect(page).to have_content('Contact')
#     expect(page).to have_title("Contact | #{base_title}")
#   end
#
# end
