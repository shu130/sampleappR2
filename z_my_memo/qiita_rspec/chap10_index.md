### Userインデックス 統合テスト（１０章）

テスト方法  | 対象ファイル
--|---|
Minitest  | test/integration/users_index_test.rb
RSpec  | spec/features/users_index_spec.rb

<!--
### Userインデックス 統合テスト 項目まとめ

1. ####  ページネーション

1. ####  ユーザの削除リンク
  adminユーザの場合
 -->

### アウトライン users_index_spec.rb
```ruby
spec/features/users_index_spec.rb

  subject { page }
  describe "index"
    it "should have page-title and heading"
    describe "pagination"
      it "should list each user"
    describe "delete links"
      context "as admin-user"

```


```ruby
spec/support/features/shared_examples.rb

                      # shared_examples

  shared_examples_for "current_path, page-title, heading" do |path_name, title_s, heading_s|
    it { subject.call; should have_current_path(path_name) }
    it { subject.call; should have_title(title_s) }
    it { subject.call; should have_selector('h1', text: heading_s) } # or
    # it { should have_content('All users') }
  end
```
```ruby
spec/support/features/shared_context.rb

                      # shared_context
  shared_context "anyone login and visit any-path" do |name_sym, path|
    let(name_sym) { create(name_sym) }
    before(:each) do
      test_login name_sym
      visit path_name
    end
  end



```

```ruby
RSpec
spec/features/users_index_spec.rb

require 'rails_helper'

RSpec.feature "UsersIndex", type: :feature do

  subject { page }

  describe "index" do
    let(:user) { create(:user) }
    before(:each) do
      test_login user
      visit users_path
    end
    it { should have_current_path(users_path) }
    it { should have_title('All users') }
    it { should have_content('All users') } # or
    it { should have_selector('h1', text: 'All users') }

    describe "pagination" do
      before(:all) { 30.times { create(:other_user) } }
      after(:all) { User.delete_all }
      it { should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      context "as non-admin-user" do
        it { should_not have_link('delete') } # or
        it { should_not have_link('delete', href: user_path(user)) }
      end

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
end
```

#### 実行結果
##### `$bin/rspec spec/features/users_index_spec.rb`

```ruby
UsersIndex
  index
    should have current path "/users"
    should have title "All users"
    should text "All users"
    should have visible css "h1" with text "All users"
    pagination
      should have visible css "div.pagination"
      should list each user
    delete links
      should not have visible link "delete"
      as admin-user
        should have visible link "delete"
        should be able to delete another user
        should not have visible link "delete"

Finished in 6.77 seconds (files took 1.76 seconds to load)
10 examples, 0 failures
```

↑  のテスト内で使っているファクトリ ↓
```ruby
RSpec
spec/factories/users.rb

FactoryBot.define do

  factory :user, class: User do
    name     "Example user"
    email    "user@example.com"
    password              "foobar"
    password_confirmation "foobar"
    admin false
  end

  factory :admin, class: User do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
    admin false
  end

  factory :sequence_user, class: User do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password              "password"
    password_confirmation "password"
    admin false
  end
end
```



```ruby
require 'rails_helper'

RSpec.feature "UsersProfile", type: :feature do

  subject { page }

  describe "profile" do
    let(:user) { create(:user) }
    before { visit user_path(user) }

    it { should have_current_path(user_path(user)) }
    it { should have_title(user.name) }
    it { should have_content(user.name) }
  end
end
```
