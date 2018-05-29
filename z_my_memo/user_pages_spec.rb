

# chap09

６つのテスト
リスト9.1 ユーザー編集ページのテスト
リスト9.9 ユーザーupdateアクションのテスト
リスト9.22 ユーザーのインデックスページのテスト
リスト9.32 ページネーションのテスト
リスト9.42 削除リンクのテスト
リスト9.48 admin属性へのアクセスが禁止されていることをテスト

# chap09
# outline
"UserPages"

  describe "index"
    it "should have title 'All uesrs'"
    it "should have content 'All users'"
    describe "pagination"
      it "should have_selector 'div.pagination'"
      it "should list each user"
        it "should have_selector 'li'"
    describe "delete links"
      it "should_not have_link 'delete'"
      context "as admin-user"
        it "should have_link 'delete'"
        it "should be able to delete another page"
          it "should change User count"

  describe "profile"
    it "should have title 'user-name'"
    it "should have content 'user-name'"

  describe "signup"
    context "with invalid infomation"
      it "should not create user"
      context "after submit"
        it "should have title 'Sign up'"
        it "should have content 'error'"
        it "should have selector 'alert-danger'"
    context "with valid infomation"
      it "should create user"
      context "after save user"
        it "should have title 'user-name'"
        it "should have selector 'alert-success'"
        it "should have link 'Log out'"

  describe "edit"
    describe "page"
    context "with invalid information"
    context "with valid information"
    describe "forbidden attributes"
      it "should not to be admin"



# chap09
# outline
"UserPages"

  describe "index"
    describe "pagination"
    describe "delete links"
      context "as admin-user"

  describe "profile"

  describe "signup"
    context "with invalid infomation"
      context "after submit"
    context "with valid infomation"
      context "after save user"

  describe "edit"
    describe "page"
    context "with invalid information"
    context "with valid information"
    describe "forbidden attributes"



# chap07, chap08

# list
リスト7.6 最初に行ったUserページspecの再現。
リスト7.9 ユーザー表示ページ用のテスト
リスト7.16 ユーザー登録の基本的なテスト
リスト7.31 お勧めのエラーメッセージテスト（無効なサインアップ情報）
リスト7.32 createアクションで保存が行われた後の動作をテスト
リスト8.26 新規ユーザー登録後にユーザーがサインインしたことをテスト

# outline
"UserPages"
  describe "profile"
  describe "signup"
    context "with invalid infomation"
      context "after submit"
    context "with valid infomation"
      context "after save user"







# chap09
spec/features/user_pages_spec.rb

require 'rails_helper'

RSpec.feature "UserPages", type: :feature do

  subject { page }

  describe "index" do
    let(:user) { create(:user) }
    before(:each) do
      test_login user
      # create(:user, name: "Bob", email: "bob@example.com")
      # create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end
    it { should have_title('All users') }
    it { should have_content('All users') }
    # it "should list each user" do
    #   User.all.each do |user|
    #     expect(page).to have_selector('li', text: user.name)
    #   end
    # end

    describe "pagination" do
      before(:all) { 30.times { create(:sequence_user) } }
      after(:all) { User.delete_all }
      it { should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }
      context "as admin-user" do
        let(:admin_user) { create(:admin_user) }
        before do

          test_login admin_user
          visit users_path
        end
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin_user)) }
      end
    end
  end

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
        expect { click_button }.not_to change(User, :count)
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
        expect { click_button submit }.to change(User, :count).by(1)
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

  describe "edit" do
    let(:user) { create(:user) }

    before do
      test_login user
      # visit edit_user_path(user)
      click_link "Settings"
    end
  #
  #   describe "page" do
  #     it { should have_title("Edit user") }
  #     it { should have_content("Update your profile") }
  #     it { should have_link("change", href: "http://gravatar.com/emails") }
  #   end
  #
  #   context "with invalid information" do
  #     # before { click_button "Save changes" }
  #
  #     let(:params) do
  #       { user: { name: "",
  #                 email: "foo@invalid",
  #                 password: "foo",
  #                 password_confirmation: "bar"} }
  #     end
  #
  #     # before { patch user_path(user), params }
  #
  #     before do
  #
  #       test_login user
  #       patch user_path(user), params
  #     end
  #
  #     # it { should have_content("danger") }
  #     it { should have_selector("div.alert.alert-danger") }
  #   end

    context "with valid infomation" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",         with: new_name
        fill_in "Email",        with: new_email
        fill_in "Password",     with: ""
        fill_in "Confirmation", with: ""
        click_button "Save changes"
      end
      it { should have_title(new_name) }
      it { should have_selector("div.alert.alert-success") }
      it { should have_link("Log out", href: logout_path) }
      it { expect(user.reload.name).to eq new_name }
      it { expect(user.reload.email).to eq new_email }
    end

  #   describe "forbidden attribute" do
  #     let(:params) do
  #       { user: { admin: true,
  #                 password: user.password,
  #                 password_confirmation: user.password } }
  #     end
  #
  #     # before { patch user_path(user), params }
  #
  #     # before do
  #     #   visit login_path
  #     #   valid_login_no_capybara user
  #     #   patch user_path(user), params
  #     # end
  #
  #     before do
  #       visit login_path
  #       valid_login user
  #       patch user_path(user), params
  #     end
  #
  #     it { expect(user.reload).not_to be_admin }
  #   end
  end
end






# chap07, chap08
spec/features/user_pages_spec.rb

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
