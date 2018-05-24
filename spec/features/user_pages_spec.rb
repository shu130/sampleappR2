require 'rails_helper'

RSpec.feature "UserPages", type: :feature do

  subject { page }

  describe "profile" do
    let(:user) { create(:user) }
    before { visit user_path(user) }

    it { should have_title(user.name) }
    it { should have_content(user.name) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    context "with invalid infomation" do
      it "should not create user" do
        expect { click_button }.to_not change(User, :count)
        # expect { click_button }.not_to change(User, :count)
      end

      context "after submit" do
        before { click_button submit }
        it { should have_title('Sign up') }
        it { should have_content('error') }
      end

    end
    context "with valid infomation" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create user" do
        expect { click_button }.to change(User, :count)
      end

      context "after save user" do
        before { click_button submit }
        let(:user) { User.find_by(email: "user@example.com") }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link("Log out") }
      end
    end
  end
end
