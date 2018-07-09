require 'rails_helper'
# require 'rspec/its'

RSpec.feature "TopPages", type: :feature do

  include SupportModule
  # include_context "setup"

  subject { page }

  describe "Home" do
    # before { visit root_path }
    # it { should have_css('h1', text: 'Sample App') }
    # it { should have_title(full_title "") }
    # it { should_not have_title(full_title "Home") }

    # 未ログイン時
    context "when non-login" do
      before { visit root_path }
      it { should have_css('h1', text: 'Sample App') }
      it { should have_title(full_title "") }
      it { should_not have_title(full_title "Home") }
    end
    # ログイン時
    context "when login" do
      let(:user) { create(:user) }
      # before { login_as(user) }
      before do
        login_as(user)
        visit root_path
      end
      # ユーザー情報
      it { should have_css('img.gravatar') }
      it { should have_css('h1', text: user.name) }
      it { should have_css('span', text: user.microposts.count) }
      it { should have_link("view my profile", href: user_path(user)) }
      # マイクロポストフォーム
      # フォームが正しいこと
      scenario "micropost-form is correct" do
        # visit login_path
        micropost_form_css  # support_module
      end

      # # マイクロポストフィード
      # describe "micropost feed" do
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
