# RailsチュートリアルテストをRSpecでやってみる                            [統合テスト編][User更新+Userインデックス]

### User更新 統合テスト（１０章）

テスト方法  | 対象ファイル
--|---|
Minitest  | test/integration/users_edit_test.rb
RSpec  | spec/features/users_edit_spec.rb

### Userインデックス 統合テスト（１０章）

テスト方法  | 対象ファイル
--|---|
Minitest  | test/integration/users_index_test.rb
RSpec  | spec/features/users_index_spec.rb


### User更新 統合テスト 項目まとめ

1. ####  更新情報が 無効

1. ####  更新情報が 有効

1. ####  admin属性をWeb経由で true にできないこと


<!-- 完成 -->
```ruby
RSpec
spec/features/users_edit_spec.rb

require 'rails_helper'

RSpec.feature "UsersEdit", type: :feature do

  subject { page }

  describe "edit" do
    let(:user) { create(:user) }
    # before do
    #   test_login user
    #   visit edit_user_path(user)
    # end
    before { visit edit_user_path(user) }

    describe "page" do
      it { should have_title("Edit user") }
      it { should have_content("Update your profile") }
      it { should have_link("change", href: "http://gravatar.com/emails") }
    end

    context "with invalid information" do
      let(:invalid_name) { "foo" }
      let(:invalid_email) { "foo@" }
      before do
        fill_in "Name",         with: invalid_name
        fill_in "Email",        with: invalid_email
        fill_in "Password",     with: ""
        fill_in "Confirmation", with: ""
        click_button "Save changes"
      end
      it { should have_content("error") }
      it { should have_selector("div.alert.alert-danger") }
    end

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
      # it { expect(response).to redirect_to user_path(user) }
      it { should have_current_path(user_path(user)) }
      it { expect(user.reload.name).to eq new_name }
      it { expect(user.reload.email).to eq new_email }
      it { should have_title(new_name) }
      # it { expect(flash[:success]).to be_present }  # できない
      it { should have_selector("div.alert.alert-success"), text: "Profile updated" }
      it { should have_link("Log out", href: logout_path) }
    end

    # ？？？ わからない
    describe "admin-attribute can not edit via web" do

    end
  end
end




```

<!-- #### 実行結果 （example単位で）
#### 実行結果
##### `$bin/rspec spec/models/user_spec.rb -e "authenticated?"` -->
