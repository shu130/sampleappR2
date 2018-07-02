

# chap07, chap08 (minitest)
require 'rails_helper'

RSpec.feature "UsersSignup", type: :feature do

  subject { page }

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    context "with invalid infomation" do
      it "should not create user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      context "after submit" do
        before { click_button submit }
        it { should have_title('Sign up') }
        it { should have_content('error') }
        it { should have_selector("div.alert.alert-danger") }
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
        expect { click_button submit }.to change(User, :count).by(1)
      end

      context "after save user" do
        before { click_button submit }
        let(:user) { User.find_by(email: "user@example.com") }

        it { should have_content(user.name) }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link("Log out") }
      end
    end
  end
end
