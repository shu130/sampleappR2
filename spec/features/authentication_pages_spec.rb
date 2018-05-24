require 'rails_helper'

RSpec.feature "AuthenticationPages", type: :feature do

  subject { page }

  describe "login" do
    visit { login_path }

    it { should have_title("Log in") }
    it { should have_content("Log in") }

    context "with invalid infomation" do
      before { click_button "Log in" }

      it { should have_title("Log in") }
      it { should have_selector("div.alert.alert-error", text: "Invalid") }

      context "after visit another page" do
        before { click_link "Home" }
        it { should_not have_selector("div.alert.alert-error") }
      end
    end

    context "with valid infomation" do
      let(:user) { create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Log in"
      end

      it { should have_title(user.name) }
      it { should have_link("Profile", href: user_path(user)) }
      it { should have_link("Log out", href: logout_path) }
      it { should_not have_link("Log in",  href: login_path) }

      context "followed by logout" do
        # １回目のログアウト
        before { click_link "Log out" }
        it { should have_link("Log in") }
        # ２回目のログアウト
        # ... どう書く？
      end

      context "with remember_me" do
        log_in_as(user, remember_me: '1')
        click_button "Log out"
        log_in_as(user, remember_me: '0')
        # ↓ minitest では assert_empty cookies['remember_token']
        its(:remember_token) { should be_blank }
      end

      context "without remember_me" do

      end
    end



  end
end
