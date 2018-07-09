require 'rails_helper'

RSpec.feature "UsersProfile", type: :feature do

  include SupportModule
  include_context "setup"

  subject { page }

  describe "profile" do
    # let(:user) { create(:user) }
    before { login_as(user) }

    # ページタイトルと見出しが正しいこと
    scenario "have page-title and heading" do
      title_heading_of_profile_page(user) # support_module
    end
    # パスが正しいこと
    scenario "user's path is correct" do
      current_path(user_path(User.last)) # support_module
    end
    # 存在すべきリンクが表示されること
    scenario "have links_of_profile_page" do
      links_of_profile_page(user)
    end
    # マイクロポストが表示されていること
    # scenario "microposts are displayed" do
    scenario "pagination list each micropost" do
      expect {
        # m1 = create(:user_post)
        # m2 = create(:user_post) # 自分のマイクロポストを２つ作成
        Micropost.paginate(page: 1).each do |post|
          have_css("h1", text: user.name)
          have_css("li#micropost-#{post.id}", text: post.content)
          have_css("span", text: user.microposts.count)
          # expect(page).to have_css("section.user_info", text: user.microposts.count)
        end
        # have_content(m1.content)
        # have_content(m2.content)
        # have_content(user.microposts.count)
      }
    end
  end
end


# アウトライン



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
