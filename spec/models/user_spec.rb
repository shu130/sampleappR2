require 'rails_helper'

RSpec.describe User, type: :model do

  # サブジェクト
  subject(:user) { build(:user) }
  # サブジェクトの有効性
  it { should be_valid }
  # 属性やメソッドの検証
  it_behaves_like "User-model respond to attribute or method"

  # validations
  describe "validations" do
    # 存在性 presence
    describe "presence" do
      # 名前、メールアドレス
      it { should validate_presence_of :name }
      it { should validate_presence_of :email }
      # NG になる
      # it { is_expected.to validate_presence_of :password }
      # it { is_expected.to validate_presence_of :password_confirmation }

      # パスワード、パスワード確認
      context "when password and confirmation is not present" do
        before { user.password = user.password_confirmation =  "  " }
        it { should_not be_valid }
      end
    end

    # 文字数 characters
    describe "characters" do
      it { should validate_length_of(:name).is_at_most(50) }
      it { should validate_length_of(:email).is_at_most(255) }
      it { should validate_length_of(:password).is_at_least(6) }
    end

    # email のフォーマット
    describe "email format" do
      # 無効なフォーマット
      context "when invalid format" do
        # 無効なオブジェクト
        it "should be invalid" do
          invalid_addr = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
          invalid_addr.each do |addr|
            user.email = addr
            expect(user).not_to be_valid
          end
        end
      end
      # 有効なフォーマット
      context "when valid format" do
        # 有効なオブジェクト
        it "should be valid" do
          valid_addr = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
          valid_addr.each do |addr|
            user.email = addr
            expect(user).to be_valid
          end
        end
      end
    end
    # email 一意性 unique
    describe "email uniqueness" do
      # 重複
      context "when email is duplicate and upcase" do
        it "should already taken (uniqueness case insensitive)" do
          user = User.create(name: "foobar", email: "foo@bar.com", password: "foobar")
          dup_user = User.new(name: user.name, email: user.email.upcase, password: user.password)
          # dup_user = User.new(name: "barfoo", email: user.email.upcase, password: "foobar")
          expect(dup_user).not_to be_valid
          expect(dup_user.errors[:email]).to include("has already been taken")
        end
      end
      # 大文字小文字が混在（before_action)
      # context "when email address is mixed-case" do
      context "when mixed-case" do
        let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
        # 小文字でDBに保存される
        it "should be saved as lower-case" do
          user.email = mixed_case_email
          user.save
          expect(user.reload.email).to eq mixed_case_email.downcase
        end
      end
    end
  end

  # パスワード認証 （has_secure_password）
  describe "has_secure_password" do
    # パスワード確認が不一致
    context "when mismatched confirmation" do
      before { user.password_confirmation = "mismatch" }
      # 無効なオブジェクト
      it { should_not be_valid }
    end
  end
  # パスワード認証 （authenticate?）
  describe "authenticate? method" do
    before { user.save }
    let(:found_user) { User.find_by(email: user.email) }
    # 正しいパスワード
    context "with valid password" do
      # 認証が 成功
      it "success authentication" do
        should eq found_user.authenticate(user.password)
      # it { should eq found_user.authenticate(user.password) }
      end
      it { expect(found_user).to be_truthy }
      it { expect(found_user).to be_valid }
    end
    # 誤ったパスワード
    context "with invalid password" do
      let(:incorrect) { found_user.authenticate("aaaaaaa") }
      # 認証が 失敗
      it "fail authentication" do
        should_not eq incorrect
      # it { should_not eq incorrect }
      end
      # 無効なオブジェクト
      it { expect(incorrect).to be_falsey }
      # it { expect(incorrect).not_to be_valid }
    end

    # バグその２対応：異なる種類のブラウザでのログアウト問題
    # モデル側の authenticated?メソッド が 一般化された後
    # false を返す（バグその２対応：異なる種類のブラウザでのログアウト問題）
    describe "return false" do
      # remember_digest が nil の場合
      context "when remember_digest is nil" do
        # authenticated?(attribute, token)メソッド
        # remember_digest は nil なので、引数token には適当な文字列をセットし、return false if digest.nil? を確認する
        let(:value) { user.authenticated?(:remember, "foo") }
        # 無効なオブジェクト（false を返す）
        it { expect(value).to be_falsey }
      end
    end
  end

  # let(:user) { create(:user) }

  # フォロー／フォロー解除
  describe "follow and unfollow" do
    let(:following) { create_list(:other_user, 30) }
    # let(:not_following) { create(:other_user) }
    before do
      user.save
      following.each do |u|
         user.follow(u) # => 自分が ３０人をフォローする
         u.follow(user) # => 他人の ３０人にフォローされる
      end
    end
    # フォロー
    describe "follow" do
      it "user is following other-user (following? method)" do
        following.each do |u|
          expect(user.following?(u)).to be_truthy
        end
      end
      it "user's following include other-user (follow method)" do
        following.each do |u|
          expect(user.following).to include(u)
        end
      end
      it "other-user's followers include user (follow method)" do
        following.each do |u|
          expect(u.followers).to include(user)
        end
      end
    end
    # フォロー解除
    describe "unfollow" do
      before do
        following.each do |u|
           user.unfollow(u) # => 自分が ３０人をフォロー解除する
        end
      end
      it "user is not following other-user (following? method)" do
        following.each do |u|
          expect(user.following?(u)).to be_falsey
        end
      end
      it "user's following does not include other-user (follow method)" do
        following.each do |u|
          expect(user.following).not_to include(u)
        end
      end
      it "other-user's followers does not include user (follow method)" do
        following.each do |u|
          expect(u.followers).not_to include(user)
        end
      end
    end
  end

  # マイクロポスト
  describe "micropost association" do
    before { user.save }
    # let(:user) { create(:user) }
    # 今日の投稿／昨日の投稿
    # インスタンス変数(user)を明示的に渡して１対多になるようにする
    # let!(:new_post) { create(:user_post, :today) }
    # let!(:old_post) { create(:user_post, :yesterday) }

    # let(:new_post) { create(:user_post, :today ) }
    # let(:old_post) { create(:user_post, :yesterday ) }

    let(:new_post) { create(:user_post, :today, user: user) }
    let(:old_post) { create(:user_post, :yesterday, user: user) }

    # let!(:new_post) { create(:user_post, :today, user: user) }
    # let!(:old_post) { create(:user_post, :yesterday, user: user) }

    # （セットアップの確認）
    # it { expect(Micropost.all.count).to eq user.microposts.count }
    # 降順に表示されること
    it "order descending" do
      new_post
      old_post
      # （セットアップの確認）
      expect(user.microposts.count).to eq 2
      expect(Micropost.all.count).to eq user.microposts.count
      expect(user.microposts.to_a).to eq [new_post, old_post]
    end
    # ユーザが破棄されるとマイクロポストも破棄される
    it "should destroy micropost (depend on destroy user)" do
      new_post
      old_post
      my_posts = user.microposts.to_a
      user.destroy
      # ※ ユーザのマイクロポストはもとから空ではないことの確認
      expect(my_posts).not_to be_empty
      user.microposts.each do |post|
        expect(Micropost.where(id: post.id)).to be_empty
      end
    end
    # マイクロポストフィード
    describe "micropost feed" do
      # let(:user) { create(:user) }
      let(:following) { create_list(:other_user, 30) }
      let(:not_following) { create(:other_user) }
      before do
        # user.save
        # following = create_list(:other_user, 30) # => 他人のユーザを３０人作成
        # 自分が１０つのマイクロポストを作成している状態
        create_list(:user_post, 10, user: user)
        create_list(:other_user_post, 10, user: not_following)
        # users # => shared_context 内で定義 create_list(:other_user, 30)
        following.each do |u|
           user.follow(u) # => 自分が ３０人をフォローする
           u.follow(user) # => 他人の ３０人にフォローされる
           # 関連付けされるファクトリをを明示的に指定
           # ３０人それぞれが、３つずつのマイクロポストを作成している状態
           create_list(:other_user_post, 3, user: u)
        end
      end
      # （セットアップの確認）
      it { expect(user.microposts.count).to eq 10 }
      it { expect(not_following.microposts.count).to eq 10 }
      # マイクロポストの合計が１００
      it { expect(Micropost.all.count).to eq 110 }

      describe "have right microposts" do
        it "following-user's post" do
          following.each do |u|
            u.microposts.each do |post|
              expect(user.feed).to include(post)
            end
          end
        end
        it "my own post" do
          user.microposts.each do |post|
            expect(user.feed).to include(post)
          end
        end
        it "not have non-following-user's post" do
          not_following.microposts.each do |post|
            expect(user.feed).not_to include(post)
          end
        end
      end
    end
  end
end







# require 'rails_helper'
#
# RSpec.describe User, type: :model do
#
#   # サブジェクト
#   subject(:user) { build(:user) }
#   # サブジェクトの有効性
#   it { should be_valid }
#   # 属性やメソッドの検証
#   it_behaves_like "User-model respond to attribute or method"
#
#   # validations
#   describe "validations" do
#     # 存在性 presence
#     describe "presence" do
#       # 名前、メールアドレス
#       it { should validate_presence_of :name }
#       it { should validate_presence_of :email }
#       # NG になる
#       # it { is_expected.to validate_presence_of :password }
#       # it { is_expected.to validate_presence_of :password_confirmation }
#
#       # パスワード、パスワード確認
#       context "when password and confirmation is not present" do
#         before { user.password = user.password_confirmation =  "  " }
#         it { should_not be_valid }
#       end
#     end
#
#     # 文字数 characters
#     describe "characters" do
#       it { should validate_length_of(:name).is_at_most(50) }
#       it { should validate_length_of(:email).is_at_most(255) }
#       it { should validate_length_of(:password).is_at_least(6) }
#     end
#
#     # email のフォーマット
#     describe "email format" do
#       # 無効なフォーマット
#       context "when invalid format" do
#         # 無効なオブジェクト
#         it "should be invalid" do
#           invalid_addr = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
#           invalid_addr.each do |addr|
#             user.email = addr
#             expect(user).not_to be_valid
#           end
#         end
#       end
#       # 有効なフォーマット
#       context "when valid format" do
#         # 有効なオブジェクト
#         it "should be valid" do
#           valid_addr = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
#           valid_addr.each do |addr|
#             user.email = addr
#             expect(user).to be_valid
#           end
#         end
#       end
#     end
#     # email 一意性 unique
#     describe "email uniqueness" do
#       # 重複
#       context "when email is duplicate and upcase" do
#         it "should already taken (uniqueness case insensitive)" do
#           user = User.create(name: "foobar", email: "foo@bar.com", password: "foobar")
#           dup_user = User.new(name: user.name, email: user.email.upcase, password: user.password)
#           # dup_user = User.new(name: "barfoo", email: user.email.upcase, password: "foobar")
#           expect(dup_user).not_to be_valid
#           expect(dup_user.errors[:email]).to include("has already been taken")
#         end
#       end
#       # 大文字小文字が混在（before_action)
#       # context "when email address is mixed-case" do
#       context "when mixed-case" do
#         let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
#         # 小文字でDBに保存される
#         it "should be saved as lower-case" do
#           user.email = mixed_case_email
#           user.save
#           expect(user.reload.email).to eq mixed_case_email.downcase
#         end
#       end
#     end
#   end
#
#   # パスワード認証 （has_secure_password）
#   describe "has_secure_password" do
#     # パスワード確認が不一致
#     context "when mismatched confirmation" do
#       before { user.password_confirmation = "mismatch" }
#       # 無効なオブジェクト
#       it { should_not be_valid }
#     end
#   end
#   # パスワード認証 （authenticate?）
#   describe "authenticate? method" do
#     before { user.save }
#     let(:found_user) { User.find_by(email: user.email) }
#     # 正しいパスワード
#     context "with valid password" do
#       # 認証が 成功
#       it "success authentication" do
#         should eq found_user.authenticate(user.password)
#       # it { should eq found_user.authenticate(user.password) }
#       end
#       it { expect(found_user).to be_truthy }
#       it { expect(found_user).to be_valid }
#     end
#     # 誤ったパスワード
#     context "with invalid password" do
#       let(:incorrect) { found_user.authenticate("aaaaaaa") }
#       # 認証が 失敗
#       it "fail authentication" do
#         should_not eq incorrect
#       # it { should_not eq incorrect }
#       end
#       # 無効なオブジェクト
#       it { expect(incorrect).to be_falsey }
#       # it { expect(incorrect).not_to be_valid }
#     end
#
#     # バグその２対応：異なる種類のブラウザでのログアウト問題
#     # モデル側の authenticated?メソッド が 一般化された後
#     # false を返す（バグその２対応：異なる種類のブラウザでのログアウト問題）
#     describe "return false" do
#       # remember_digest が nil の場合
#       context "when remember_digest is nil" do
#         # authenticated?(attribute, token)メソッド
#         # remember_digest は nil なので、引数token には適当な文字列をセットし、return false if digest.nil? を確認する
#         let(:value) { user.authenticated?(:remember, "foo") }
#         # 無効なオブジェクト（false を返す）
#         it { expect(value).to be_falsey }
#       end
#     end
#   end
#
#   # let(:user) { create(:user) }
#
#   # フォロー／フォロー解除
#   describe "follow and unfollow" do
#     # before { user.save }
#     # let(:other_user) { create(:other_user) }
#     # before { user.follow(other_user) }
#     let(:other_user) { create(:other_user) }
#     before do
#       user.save
#       user.follow(other_user)
#     end
#     # フォロー
#     describe "follow" do
#       # before { user.follow(other_user) }
#       it "user is following other_user" do
#         expect(user.following?(other_user)).to be_truthy
#       end
#       it "user's following include other_user" do
#         expect(user.following).to include(other_user)
#       end
#       it "other_user's followers include user" do
#         expect(other_user.followers).to include(user)
#       end
#     end
#     # フォロー解除
#     describe "unfollow" do
#       before { user.unfollow(other_user) }
#       # binding.pry
#       it "user is not following other_user" do
#         expect(user.following?(other_user)).to be_falsey
#       end
#       it "user's following does not include other_user" do
#         expect(user.following).not_to include(other_user)
#       end
#       it "other_user's followers does not include user" do
#         expect(other_user.followers).not_to include(user)
#       end
#     end
#   end
#
#   # マイクロポスト
#   describe "micropost association" do
#     before { user.save }
#     # let(:user) { create(:user) }
#     # 今日の投稿／昨日の投稿
#     # インスタンス変数(user)を明示的に渡して１対多になるようにする
#     # let!(:new_post) { create(:user_post, :today) }
#     # let!(:old_post) { create(:user_post, :yesterday) }
#     let!(:new_post) { create(:user_post, :today, user: user) }
#     let!(:old_post) { create(:user_post, :yesterday, user: user) }
#     # （セットアップの確認）
#     it { expect(Micropost.all.count).to eq user.microposts.count }
#     # 降順に表示されること
#     it "order descending" do
#       expect(user.microposts.to_a).to eq [new_post, old_post]
#     end
#     # ユーザが破棄されるとマイクロポストも破棄される
#     it "should destroy micropost (depend on destroy user)" do
#       my_posts = user.microposts.to_a
#       user.destroy
#       # ※ ユーザのマイクロポストはもとから空ではないことの確認
#       expect(my_posts).not_to be_empty
#       user.microposts.each do |post|
#         expect(Micropost.where(id: post.id)).to be_empty
#       end
#     end
#     # マイクロポストフィード
#     describe "micropost feed" do
#       # let(:user) { create(:user) }
#       let(:followed_user) { create(:other_user) }
#       let(:unfollowed_user) { create(:other_user) }
#       before do
#         user.save
#         user.follow(followed_user)
#         5.times { followed_user.microposts.create(content: "aaaaaaaaaa") }
#         5.times { unfollowed_user.microposts.create(content: "bbbbbbbbbb") }
#       end
#       describe "have right microposts" do
#         it "following-user's post" do
#           followed_user.microposts.each do |post|
#             expect(user.feed).to include(post)
#           end
#         end
#         it "my own post" do
#           user.microposts.each do |post|
#             expect(user.feed).to include(post)
#           end
#         end
#         it "not have non-following-user's post" do
#           unfollowed_user.microposts.each do |post|
#             expect(user.feed).not_to include(post)
#           end
#         end
#       end
#     end
#   end
# end




# # アウトライン
# RSpec.describe User, type: :model do
#   # validations
#   describe "validations"
#     # 存在性 presence
#     describe "presence"
#       # 名前、メールアドレス
#       it "name and email should not to be empty/falsy"
#       # パスワード、パスワード確認
#       context "when password and confirmation is not present"
#         it "@user is inavlid"
#     # 文字数 characters
#     describe "characters"
#       # 名前： 最大 50 文字
#       context "when name is too long"
#         it "@user is inavlid"
#       # メールアドレス： 最大 255 文字
#       context "when email is too long"
#         it "@user is inavlid"
#       # パスワード、パスワード確認： 最小 6 文字
#       describe "when password is too short"
#         it "@user is inavlid"
#     # email のフォーマット
#     describe "email format"
#       # invalid なフォーマット
#       context "when invalid format"
#         it "@user is inavlid"
#       # valid なフォーマット
#       context "when valid format"
#         it "@user is valid"
#     # email 一意性 unique
#     describe "email uniqueness"
#       # email が 大文字の場合
#       context "when email is upcase"
#         # 重複（invalid）となること
#         it "should already taken (uniqueness case insensitive)"
#       # 大文字小文字が混在（before_action)
#       context "when mixed-case"
#         # 小文字でDBに保存される
#         it "should be saved as lower-case"
#
#   # パスワード認証 （has_secure_password）
#   describe "has_secure_password"
#     # パスワード確認が不一致
#     context "when mismatched confirmation"
#       it "@user is inavlid"
#   # パスワード認証 （authenticate?）
#   describe "authenticate? method"
#     # 正しいパスワード
#     context "with valid password"
#       # 認証が 成功
#       it "success authentication"
#       # 誤ったパスワード
#     context "with invalid password"
#       it "fail authentication"
#     # false を返す（バグその２対応：異なる種類のブラウザでのログアウト問題）
#     describe "return false"
#       # remember_digest が nil の場合
#       context "when remember_digest is nil"
#         it "should be falsy"
#
#   # フォロー／フォロー解除
#   describe "follow and unfollow"
#     # フォロー
#     describe "follow"
#       # 自分は相手をフォローしている（following?メソッド）
#       it "user is following other_user"
#       # フォロー中のユーザの中に、相手が含まれている（followingメソッド）
#       it "user's following include other_user"
#       # 相手のフォロワーの中に、自分が含まれている（followersメソッド）
#       it "other_user's followers include user"
#     # フォロー解除
#     describe "unfollow"
#       it "user is not following other_user"
#       it "user's following does not include other_user"
#       it "other_user's followers does not include user"
#
#   # マイクロポスト
#   describe "micropost association"
#     # 降順に表示されること
#     it "order descending"
#     # ユーザが破棄されるとマイクロポストも破棄される
#     it "should destroy micropost (depend on destroy user)"
#     # マイクロポストフィード
#     describe "micropost feed"
#       # 表示が正しいこと
#       describe "have right microposts"
#         # フォロー中のユーザのマイクロポスト
#         it "following-user's post"
#         # 自分自身のマイクロポスト
#         it "my own post"
#         # 未フォローのユーザのマイクロポストは非表示
#         it "not have non-following-user's post"
# end






# require 'rails_helper'
#
# RSpec.describe User, type: :model do
#
#   # サブジェクト
#   subject(:user) { build(:user) }
#   # サブジェクトの有効性
#   it { should be_valid }
#   # 属性やメソッドの検証
#   it_behaves_like "User-model respond to attribute or method"
#
#   # validations
#   describe "validations" do
#     # 存在性 presence
#     describe "presence" do
#       # 名前、メールアドレス
#       it { should validate_presence_of :name }
#       it { should validate_presence_of :email }
#       # it { is_expected.to validate_presence_of :name }
#       # it { is_expected.to validate_presence_of :email }
#
#       # NG になる
#       # it { is_expected.to validate_presence_of :password }
#       # it { is_expected.to validate_presence_of :password_confirmation }
#
#       # パスワード、パスワード確認
#       context "when password and confirmation is not present" do
#         before { user.password = user.password_confirmation =  "  " }
#         it { should_not be_valid }
#       end
#     end
#
#     # 文字数 characters
#     describe "characters" do
#       # 名前： 最大 50 文字
#       # context "when name is too long" do
#       #   before { user.name = "a" * 51 }
#       #   it { should_not be_valid }
#       # end
#       it { should validate_length_of(:name).is_at_most(16) }
#       # メールアドレス： 最大 255 文字
#       # context "when email is too long" do
#       #   before { user.email = "a" * 255 + "@example.com" }
#       #   it { should_not be_valid }
#       # end
#       it { should validate_length_of(:name).is_at_most(16) }
#       # パスワード、パスワード確認： 最小 6 文字
#       describe "when password is too short" do
#         before { user.password = user.password_confirmation = "a" * 5 }
#         it { should_not be_valid }
#       end
#     end
#
#     # email のフォーマット
#     describe "email format" do
#       # 無効なフォーマット
#       context "when invalid format" do
#         # 無効なオブジェクト
#         it "should be invalid" do
#           invalid_addr = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
#           invalid_addr.each do |addr|
#             user.email = addr
#             expect(user).not_to be_valid
#           end
#         end
#       end
#       # 有効なフォーマット
#       context "when valid format" do
#         # 有効なオブジェクト
#         it "should be valid" do
#           valid_addr = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
#           valid_addr.each do |addr|
#             user.email = addr
#             expect(user).to be_valid
#           end
#         end
#       end
#     end
#     # email 一意性 unique
#     describe "email uniqueness" do
#       # 重複
#       context "when email is duplicate and upcase" do
#         it "should already taken (uniqueness case insensitive)" do
#           user = User.create(name: "foobar", email: "foo@bar.com", password: "foobar")
#           dup_user = User.new(name: "barfoo", email: user.email.upcase, password: "foobar")
#           expect(dup_user).not_to be_valid
#           expect(dup_user.errors[:email]).to include("has already been taken")
#         end
#       end
#       # 大文字小文字が混在（before_action)
#       # context "when email address is mixed-case" do
#       context "when mixed-case" do
#         let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
#         # 小文字でDBに保存される
#         it "should be saved as lower-case" do
#           user.email = mixed_case_email
#           user.save
#           expect(user.reload.email).to eq mixed_case_email.downcase
#         end
#       end
#     end
#   end
#
#   # パスワード認証 （has_secure_password）
#   describe "has_secure_password" do
#     # パスワード確認が不一致
#     context "when mismatched confirmation" do
#       before { user.password_confirmation = "mismatch" }
#       # 無効なオブジェクト
#       it { should_not be_valid }
#     end
#   end
#   # パスワード認証 （authenticate?）
#   describe "authenticate? method" do
#     before { user.save }
#     let(:found_user) { User.find_by(email: user.email) }
#     # 正しいパスワード
#     context "with valid password" do
#       # 認証が 成功
#       it "success authentication" do
#         should eq found_user.authenticate(user.password)
#       # it { should eq found_user.authenticate(user.password) }
#       end
#     end
#     # 誤ったパスワード
#     context "with invalid password" do
#       let(:incorrect) { found_user.authenticate("aaaaaaa") }
#       # 認証が 失敗
#       it "fail authentication" do
#         should_not eq incorrect
#       # it { should_not eq incorrect }
#       end
#       # 無効なオブジェクト
#       it { expect(incorrect).to be_falsey }
#     end
#
#     # バグその２対応：異なる種類のブラウザでのログアウト問題
#     # モデル側の authenticated?メソッド が 一般化された後
#     # false を返す（バグその２対応：異なる種類のブラウザでのログアウト問題）
#     describe "return false" do
#       # remember_digest が nil の場合
#       context "when remember_digest is nil" do
#         # authenticated?(attribute, token)メソッド
#         # remember_digest は nil なので、引数token には適当な文字列をセットし、return false if digest.nil? を確認する
#         let(:value) { user.authenticated?(:remember, "foo") }
#         # 無効なオブジェクト（false を返す）
#         it { expect(value).to be_falsey }
#       end
#     end
#   end
#
#   # let(:user) { create(:user) }
#
#   # フォロー／フォロー解除
#   describe "follow and unfollow" do
#     before { user.save }
#     let(:other_user) { create(:other_user) }
#     before { user.follow(other_user) }
#     # フォロー
#     describe "follow" do
#       # before { user.follow(other_user) }
#       it "user is following other_user" do
#         expect(user.following?(other_user)).to be_truthy
#       end
#       it "user's following include other_user" do
#         expect(user.following).to include(other_user)
#       end
#       it "other_user's followers include user" do
#         expect(other_user.followers).to include(user)
#       end
#     end
#     # フォロー解除
#     describe "unfollow" do
#       before { user.unfollow(other_user) }
#       # binding.pry
#       it "user is not following other_user" do
#         expect(user.following?(other_user)).to be_falsey
#       end
#       it "user's following does not include other_user" do
#         expect(user.following).not_to include(other_user)
#       end
#       it "other_user's followers does not include user" do
#         expect(other_user.followers).not_to include(user)
#       end
#     end
#   end
#
#   # マイクロポスト
#   describe "micropost association" do
#     # before { @user = user.save }
#     # let!(:user) { create(:user) }
#     # let(:my_post) { build(:user_post) }
#
#     # # let! にしておかないと、user.microposts.to_a が []（空）になってしまう
#     # let!(:new_post) { create(:user_post, created_at: 1.hour.ago, user: user) }
#     # let!(:old_post) { create(:user_post, created_at: 1.day.ago, user: user) }
#     # let!(:new_post) { create(:user_post, :today, user: user) }
#     # let!(:old_post) { create(:user_post, :yesterday, user: user) }
#     let!(:new_post) { create(:user_post, :today) }
#     let!(:old_post) { create(:user_post, :yesterday) }
#     # （セットアップの確認）
#     it { expect(Micropost.all.count).to eq user.microposts.count }
#
#     # 降順に表示されること
#     it "order descending" do
#       expect(user.microposts.to_a).to eq [new_post, old_post]
#     end
#     # ユーザが破棄されるとマイクロポストも破棄される
#     it "should destroy micropost (depend on destroy user)" do
#       my_posts = user.microposts.to_a
#       user.destroy
#       # ※ ユーザのマイクロポストはもとから空ではないことの確認
#       expect(my_posts).not_to be_empty
#       user.microposts.each do |post|
#         expect(Micropost.where(id: post.id)).to be_empty
#       end
#     end
#     # マイクロポストフィード
#     describe "micropost feed" do
#       # let(:user) { create(:user) }
#       let(:followed_user) { create(:other_user) }
#       let(:unfollowed_user) { create(:other_user) }
#       before do
#         user.save
#         user.follow(followed_user)
#         5.times { followed_user.microposts.create(content: "aaaaaaaaaa") }
#         5.times { unfollowed_user.microposts.create(content: "bbbbbbbbbb") }
#       end
#       describe "have right microposts" do
#         it "following-user's post" do
#           followed_user.microposts.each do |post|
#             expect(user.feed).to include(post)
#           end
#         end
#         it "my own post" do
#           user.microposts.each do |post|
#             expect(user.feed).to include(post)
#           end
#         end
#         it "not have non-following-user's post" do
#           unfollowed_user.microposts.each do |post|
#             expect(user.feed).not_to include(post)
#           end
#         end
#       end
#     end
#   end
# end





# $ rails consoles
# Running via Spring preloader in process 5665
# Loading development environment (Rails 5.1.4)
# [2] pry(main)> new = FactoryBot.create(:user_post, created_at: 1.hour.ago)
#    (0.2ms)  begin transaction
#   User Exists (4.3ms)  SELECT  1 AS one FROM "users" WHERE LOWER("users"."email") = LOWER(?) LIMIT ?  [["email", "user@example.com"], ["LIMIT", 1]]
#   SQL (10.7ms)  INSERT INTO "users" ("name", "email", "created_at", "updated_at", "password_digest", "activation_digest") VALUES (?, ?, ?, ?, ?, ?)  [["name", "Example user"], ["email", "user@example.com"], ["created_at", "2018-07-28 06:38:25.737976"], ["updated_at", "2018-07-28 06:38:25.737976"], ["password_digest", "$2a$10$DlaWshKnL9I4QLN0WPyhXOPVZ3ppAiscmQl.KsEHHoYEAR.SJ//7i"], ["activation_digest", "$2a$10$MVM9bfbXPIiIHy0tkCsSjeD4Q1yq/TXzUQH3AxQ4wQZPmvOSvTg1e"]]
#    (9.8ms)  commit transaction
#    (0.2ms)  begin transaction
#   SQL (8.6ms)  INSERT INTO "microposts" ("content", "user_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["content", "Sit quae inventore minus aut."], ["user_id", 1], ["created_at", "2018-07-28 05:38:24.675372"], ["updated_at", "2018-07-28 06:38:25.922703"]]
#    (8.4ms)  commit transaction
# => #<Micropost:0x007f80cab594e0
#  id: 1,
#  content: "Sit quae inventore minus aut.",
#  user_id: 1,
#  created_at: Sat, 28 Jul 2018 05:38:24 UTC +00:00,
#  updated_at: Sat, 28 Jul 2018 06:38:25 UTC +00:00,
#  picture: nil>
# [3] pry(main)>
# [4] pry(main)> old = FactoryBot.create(:user_post, created_at: 1.day.ago)
#    (0.6ms)  begin transaction
#   User Exists (4.1ms)  SELECT  1 AS one FROM "users" WHERE LOWER("users"."email") = LOWER(?) LIMIT ?  [["email", "user@example.com"], ["LIMIT", 1]]
#    (0.1ms)  rollback transaction
# ActiveRecord::RecordInvalid: Validation failed: Email has already been taken
# from /home/vagrant/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/activerecord-5.1.4/lib/active_record/validations.rb:78:in `raise_validation_error'














# require 'rails_helper'
#
# RSpec.describe User, type: :model do
#
#   let(:user) { build(:user) }
#
#   subject { user }
#
#   it { should be_valid }
#   it_behaves_like "User-model respond to attribute or method"
#
#   # validations
#   describe "validations" do
#     # 存在性 presence
#     describe "presence" do
#       # 名前、メールアドレス
#       it { is_expected.to validate_presence_of :name }
#       it { is_expected.to validate_presence_of :email }
#
#       # NG になる
#       # it { is_expected.to validate_presence_of :password }
#       # it { is_expected.to validate_presence_of :password_confirmation }
#
#       # パスワード、パスワード確認
#       context "when password and confirmation is not present" do
#         before { user.password = user.password_confirmation =  "  " }
#         it { should_not be_valid }
#       end
#     end
#
#     # 文字数 characters
#     describe "characters" do
#       # 名前： 最大 50 文字
#       context "when name is too long" do
#         before { user.name = "a" * 51 }
#         it { should_not be_valid }
#       end
#       # メールアドレス： 最大 255 文字
#       context "when email is too long" do
#         before { user.email = "a" * 255 + "@example.com" }
#         it { should_not be_valid }
#       end
#       # パスワード、パスワード確認： 最小 6 文字
#       describe "when password is too short" do
#         before { user.password = user.password_confirmation = "a" * 5 }
#         it { should_not be_valid }
#       end
#     end
#
#     # email のフォーマット
#     describe "email format" do
#       # 無効なフォーマット
#       context "when invalid format" do
#         # 無効なオブジェクト
#         it "should be invalid" do
#           invalid_addr = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
#           invalid_addr.each do |addr|
#             user.email = addr
#             expect(user).not_to be_valid
#           end
#         end
#       end
#       # 有効なフォーマット
#       context "when valid format" do
#         # 有効なオブジェクト
#         it "should be valid" do
#           valid_addr = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
#           valid_addr.each do |addr|
#             user.email = addr
#             expect(user).to be_valid
#           end
#         end
#       end
#     end
#     # email 一意性 unique
#     describe "email uniqueness" do
#       # 重複
#       context "when already taken" do
#         before do
#           dup_user = user.dup
#           dup_user.email = user.email.upcase
#           dup_user.save
#         end
#         it { should_not be_valid }
#       end
#       # 大文字小文字が混在（before_action)
#       # context "when email address is mixed-case" do
#       context "when mixed-case" do
#         let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
#         # 小文字でDBに保存される
#         it "should be saved as lower-case" do
#           user.email = mixed_case_email
#           user.save
#           expect(user.reload.email).to eq mixed_case_email.downcase
#         end
#       end
#     end
#   end
#
#   # パスワード認証 （has_secure_password）
#   describe "has_secure_password" do
#     # パスワード確認が不一致
#     context "when mismatched confirmation" do
#       before { user.password_confirmation = "mismatch" }
#       # 無効なオブジェクト
#       it { should_not be_valid }
#     end
#   end
#
#   # パスワード認証 （authenticate?）
#   # ユーザー認証が正しいこと
#   describe "authenticate? method" do
#     before { user.save }
#     let(:found_user) { User.find_by(email: user.email) }
#     # 正しいパスワード
#     context "with valid password" do
#       it { should eq found_user.authenticate(user.password) }
#     end
#     # 誤ったパスワード
#     context "with invalid password" do
#       let(:incorrect) { found_user.authenticate("aaaaaaa") }
#       # 認証が 失敗
#       it { should_not eq incorrect }
#       # 無効なオブジェクト
#       it { expect(incorrect).to be_falsey }
#     end
#
#     # バグその２対応：異なる種類のブラウザでのログアウト問題
#     # モデル側の authenticated?メソッド が 一般化された後
#     # false を返す
#     describe "return false" do
#       # remember_digest が nil の場合
#       context "with nil remember_digest" do
#         # authenticated?(attribute, token)メソッド
#         # remember_digest は nil なので、引数token には適当な文字列をセットし、return false if digest.nil? を確認する
#         let(:value) { user.authenticated?(:remember, "foo") }
#         # 無効なオブジェクト（false を返す）
#         it { expect(value).to be_falsey }
#       end
#     end
#   end
#
#   # フォロー／フォロー解除 関連のメソッド
#   describe "follow and unfollow" do
#     let!(:user) { create(:user) }
#     let!(:other_user) { create(:other_user) }
#     # フォロー
#     describe "follow" do
#       # let(:user) { create(:user) }
#       # let(:other_user) { create(:other_user) }
#       before { user.follow(other_user) }
#       context "for user" do
#         # before { user.follow(other_user) }
#         # フォロー中？ （論理値メソッド）
#         it { expect(user.following?(other_user)).to be_truthy }
#         # it { should be_following(other_user) }
#         # its(:following) { should include(other_user) }
#         it { expect(user.following).to include(other_user) }
#       end
#       context "for other-user" do
#         # subject { other_user }
#         # before { other_user.follow(user) }
#         # it { expect(other_user.following?(user)).to be_truthy }
#         # its(:followers) { should include(user) }
#         it { expect(other_user.followers).to include(user) }
#       end
#     end
#     # フォロー解除
#     describe "unfollow" do
#       # let(:user) { create(:user) }
#       # let(:other_user) { create(:other_user) }
#       before { user.unfollow(other_user) }
#       context "for user" do
#         # before { user.unfollow(other_user) }
#         # フォロー中？ （論理値メソッド）
#         it { expect(user.following?(other_user)).to be_falsey }
#         # it { should_not be_following(other_user) }
#         # its(:following) { should_not include(other_user) }
#         it { expect(user.following).not_to include(other_user) }
#       end
#       context "for other-user" do
#         # subject { other_user }
#         # before { other_user.unfollow(user) }
#         # it { expect(other_user.following?(user)).to be_falsey }
#         # its(:followers) { should_not include(user) }
#         it { expect(other_user.followers).not_to include(user) }
#       end
#     end
#
#     # マイクロポスト
#     describe "micropost association" do
#       let(:user) { create(:user) }
#       let(:my_post) { build(:user_post) }
#       let!(:old_post) { create(:user_post, created_at: 1.day.ago) }
#       let!(:new_post) { create(:user_post, created_at: 1.hour.ago) }
#
#       # 降順に表示されること
#       it "order descending" do
#         expect(user.microposts.to_a).to eq [new_post, old_post]
#       end
#       # ユーザが破棄されるとマイクロポストも破棄される
#       it "depends on destroy-user" do
#         my_posts = user.microposts.to_a
#         user.destroy
#         expect(my_posts).not_to be_empty
#         user.microposts.each do |post|
#           expect(Micropost.where(id: micropost.id)).to be_empty
#         end
#       end
#       # マイクロポストフィード
#       describe "micropost feed" do
#         # let(:user) { create(:user) }
#         let(:followed_user) { create(:other_user) }
#         let(:unfollowed_user) { create(:other_user) }
#         before do
#           user.follow(followed_user)
#           5.times { followed_user.microposts.create(content: "aaaaaaaaaa") }
#           5.times { unfollowed_user.microposts.create(content: "bbbbbbbbbb") }
#         end
#         describe "have right microposts" do
#           it "following-user's post" do
#             followed_user.microposts.each do |post|
#               expect(user.feed).to include(post)
#             end
#           end
#           it "my own post" do
#             user.microposts.each do |post|
#               expect(user.feed).to include(post)
#             end
#           end
#           it "not have non-following-user's post" do
#             unfollowed_user.microposts.each do |post|
#               expect(user.feed).not_to include(post)
#             end
#           end
#         end
#       end
#     end
#   end
# end



# require 'rails_helper'
#
# RSpec.describe User, type: :model do
#
#   let(:user) { build(:user) }
#
#   subject { user }
#
#   it { should be_valid }
#   it_behaves_like "User-model respond to attribute or method"
#
#   # validations
#   describe "validations" do
#     # 存在性 presence
#     describe "presence" do
#       # 名前、メールアドレス
#       it { is_expected.to validate_presence_of :name }
#       it { is_expected.to validate_presence_of :email }
#
#       # NG になる
#       # it { is_expected.to validate_presence_of :password }
#       # it { is_expected.to validate_presence_of :password_confirmation }
#
#       # パスワード、パスワード確認
#       context "when password and confirmation is not present" do
#         before { user.password = user.password_confirmation =  "  " }
#         it { should_not be_valid }
#       end
#     end
#
#     # 文字数 characters
#     describe "characters" do
#       # 名前： 最大 50 文字
#       context "when name is too long" do
#         before { user.name = "a" * 51 }
#         it { should_not be_valid }
#       end
#       # メールアドレス： 最大 255 文字
#       context "when email is too long" do
#         before { user.email = "a" * 255 + "@example.com" }
#         it { should_not be_valid }
#       end
#       # パスワード、パスワード確認： 最小 6 文字
#       describe "when password is too short" do
#         before { user.password = user.password_confirmation = "a" * 5 }
#         it { should_not be_valid }
#       end
#     end
#
#     # email のフォーマット
#     describe "email format" do
#       # 無効なフォーマット
#       context "when invalid format" do
#         # 無効なオブジェクト
#         it "should be invalid" do
#           invalid_addr = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
#           invalid_addr.each do |addr|
#             user.email = addr
#             expect(user).not_to be_valid
#           end
#         end
#       end
#       # 有効なフォーマット
#       context "when valid format" do
#         # 有効なオブジェクト
#         it "should be valid" do
#           valid_addr = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
#           valid_addr.each do |addr|
#             user.email = addr
#             expect(user).to be_valid
#           end
#         end
#       end
#     end
#     # email 一意性 unique
#     describe "email uniqueness" do
#       # 重複
#       context "when already taken" do
#         before do
#           dup_user = user.dup
#           dup_user.email = user.email.upcase
#           dup_user.save
#         end
#         it { should_not be_valid }
#       end
#       # 大文字小文字が混在（before_action)
#       # context "when email address is mixed-case" do
#       context "when mixed-case" do
#         let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
#         # 小文字でDBに保存される
#         it "should be saved as lower-case" do
#           user.email = mixed_case_email
#           user.save
#           expect(user.reload.email).to eq mixed_case_email.downcase
#         end
#       end
#     end
#   end
#
#   # パスワード認証 （has_secure_password）
#   describe "has_secure_password" do
#     # パスワード確認が不一致
#     context "when mismatched confirmation" do
#       before { user.password_confirmation = "mismatch" }
#       # 無効なオブジェクト
#       it { should_not be_valid }
#     end
#   end
#
#   # パスワード認証 （authenticate?）
#   # ユーザー認証が正しいこと
#   describe "authenticate? method" do
#     before { user.save }
#     let(:found_user) { User.find_by(email: user.email) }
#     # 正しいパスワード
#     context "with valid password" do
#       it { should eq found_user.authenticate(user.password) }
#     end
#     # 誤ったパスワード
#     context "with invalid password" do
#       let(:incorrect) { found_user.authenticate("aaaaaaa") }
#       # 認証が 失敗
#       it { should_not eq incorrect }
#       # 無効なオブジェクト
#       it { expect(incorrect).to be_falsey }
#     end
#
#     # バグその２対応：異なる種類のブラウザでのログアウト問題
#
#     # モデル側の authenticated?メソッド を 一般化する前
#
#     # # authenticated?メソッド 記憶ダイジェスト の nilガード
#     # describe "authenticated? with nil remember_digest" do
#     #   # 引数の remember_token には 適当な値をセット
#     #   let(:value) { user.authenticated?("") }
#     #   it { expect(value).to be_falsey }
#     # end
#
#     # モデル側の authenticated?メソッド が 一般化された後
#
#     # false を返す
#     describe "return false" do
#       # remember_digest が nil の場合
#       context "with nil remember_digest" do
#         # authenticated?(attribute, token)メソッド
#         # remember_digest は nil なので、引数token には適当な文字列をセットし、return false if digest.nil? を確認する
#         let(:value) { user.authenticated?(:remember, "foo") }
#         # 無効なオブジェクト（false を返す）
#         it { expect(value).to be_falsey }
#       end
#     end
#   end
#
#   # フォロー／フォロー解除 関連のメソッド
#   describe "follow and unfollow" do
#     # let(:user) { create(:user) }
#     # let(:other_user) { create(:other_user) }
#     # フォロー
#     describe "follow" do
#       let(:user) { create(:user) }
#       let(:other_user) { create(:other_user) }
#       # let(:other_user) { create(:other_user) }
#       context "for user" do
#         before { user.follow(other_user) }
#         # フォロー中？ （論理値メソッド）
#         it { expect(user.following?(other_user)).to be_truthy }
#         # it { should be_following(other_user) }
#         its(:following) { should include(other_user) }
#       end
#       context "for other-user" do
#         subject { other_user }
#         before { other_user.follow(user) }
#         it { expect(other_user.following?(user)).to be_truthy }
#         its(:followers) { should include(user) }
#       end
#     end
#
#     # フォロー解除
#     describe "unfollow" do
#       let(:user) { create(:user) }
#       let(:other_user) { create(:other_user) }
#       # before { user.unfollow(other_user) }
#       context "for user" do
#         before { user.unfollow(other_user) }
#         # フォロー中？ （論理値メソッド）
#         it { expect(user.following?(other_user)).to be_falsey }
#         # it { should_not be_following(other_user) }
#         its(:following) { should_not include(other_user) }
#       end
#       context "for other-user" do
#         subject { other_user }
#         before { other_user.unfollow(user) }
#         it { expect(other_user.following?(user)).to be_falsey }
#         its(:followers) { should_not include(user) }
#       end
#     end
#
#
#     describe "micropost association" do
#       let(:user) { create(:user) }
#       let(:my_post) { build(:user_post) }
#       let!(:old_post) { create(:user_post, created_at: 1.day.ago) }
#       let!(:new_post) { create(:user_post, created_at: 1.hour.ago) }
#       # 降順
#       it "order descending" do
#         expect(user.microposts.to_a).to eq [new_post, old_post]
#       end
#       # ユーザが破棄されるとマイクロポストも破棄される
#       it "depends on destroy-user" do
#         my_posts = user.microposts.to_a
#         user.destroy
#         expect(my_posts).not_to be_empty
#         user.microposts.each do |post|
#           expect(Micropost.where(id: micropost.id)).to be_empty
#         end
#       end
#       # マイクロポストフィード
#       describe "micropost feed" do
#         # let(:user) { create(:user) }
#         let(:followed_user) { create(:other_user) }
#         let(:unfollowed_user) { create(:other_user) }
#         before do
#           user.follow(followed_user)
#           5.times { followed_user.microposts.create(content: "aaaaaaaaaa") }
#           5.times { unfollowed_user.microposts.create(content: "bbbbbbbbbb") }
#         end
#         describe "have right microposts" do
#           it "following-user's post" do
#             followed_user.microposts.each do |post|
#               expect(user.feed).to include(post)
#             end
#           end
#           it "my own post" do
#             user.microposts.each do |post|
#               expect(user.feed).to include(post)
#             end
#           end
#           it "not have non-following-user's post" do
#             unfollowed_user.microposts.each do |post|
#               expect(user.feed).not_to include(post)
#             end
#           end
#         end
#       end
#     end
#   end
# end
#



# irb(main):003:0* u = FactoryBot.build(:user)
#   User Load (5.1ms)  SELECT  "users".* FROM "users" WHERE "users"."email" = ? LIMIT ?  [["email", "user@example.com"], ["LIMIT", 1]]
# => #<User id: 101, name: "Example user", email: "user@example.com", created_at: "2018-06-30 12:53:11", updated_at: "2018-06-30 13:11:22", password_digest: "$2a$10$9jZ7Ph/JsHpTd1zMHo/jGe/0rGoS3WFBBTArLQJ8M.D...", remember_digest: nil, admin: false, activation_digest: "$2a$10$bY5Rc5SDJKlp0RV09cbQ5eQAQiOD.3AimKBkBskdZnj...", activated: false, activated_at: nil>

# アウトライン



# require 'rails_helper'
#
# RSpec.describe User, type: :model do
#
#   before do
#     @user = User.new(name: "Example User",
#                      email: "user@example.com",
#                      password: "foobar",
#                      password_confirmation: "foobar")
#   end
#
#   subject { @user }
#
#   it { should respond_to(:name) }
#   it { should respond_to(:email) }
#   it { should respond_to(:password) }
#   it { should respond_to(:password_confirmation) }
#   it { should respond_to(:authenticate) }
#   it { should respond_to(:password_digest) }
#   it { should respond_to(:remember_digest) }
#   it { should respond_to(:activation_digest) }
#
#   # 存在性 presence
#   describe "when name is not present" do
#     before { user.name = "   " }
#     it { should_not be_valid }
#   end
#
#   describe "when email is not present" do
#     before { @user.email = "   " }
#     it { should_not be_valid }
#   end
#
#   describe "when password is not present" do
#     before { @user.password = @user.password_confirmation =  "  " }
#     it { should_not be_valid }
#   end
#
#   # 文字数
#   describe "when name is too long" do
#     before { @user.name = "a" * 51 }
#     it { should_not be_valid }
#   end
#
#   describe "when email is too long" do
#     before { @user.email = "a" * 255 + "@example.com" }
#     it { should_not be_valid }
#   end
#
#   describe "when password is too short" do
#     before { @user.password = @user.password_confirmation = "a" * 5 }
#     it { should_not be_valid }
#   end
#
#   # email のフォーマット
#   describe "when email format is invalid" do
#     it "should be invalid" do
#       invalid_addr = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
#       invalid_addr.each do |addr|
#         @user.email = addr
#         expect(@user).not_to be_valid
#       end
#     end
#   end
#
#   describe "when email format is valid" do
#     it "should be valid" do
#       valid_addr = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
#       valid_addr.each do |addr|
#         @user.email = addr
#         expect(@user).to be_valid
#       end
#     end
#   end
#
#   # email 一意性 unique
#   describe "when email address is already taken" do
#     before do
#       dup_user = @user.dup
#       dup_user.email = @user.email.upcase
#       dup_user.save
#     end
#     it { should_not be_valid }
#   end
#
#   # email の beforeフィルタ
#   describe "when email address is mixed-case" do
#     let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
#     it "should be saved as lower-case" do
#       @user.email = mixed_case_email
#       @user.save
#       expect(@user.reload.email).to eq mixed_case_email.downcase
#     end
#   end
#
#   # :password_confirmation
#   describe "when password doesn't match confirmation" do
#     before { @user.password_confirmation = "mismatch" }
#     it { should_not be_valid }
#   end
#
#   # パスワード認証 authenticate
#   describe "returen value of authenticate method" do
#     before { @user.save }
#     let(:found_user) { User.find_by(email: @user.email) }
#
#     context "with valid password" do
#       it { should eq found_user.authenticate(@user.password) }
#     end
#     context "with invalid password" do
#       let(:incorrect) { found_user.authenticate("invalid") }
#       it { should_not eq incorrect }
#       it { expect(incorrect).to be_falsey }
#     end
#   end
#
#   # バグその２対応：異なる種類のブラウザでのログアウト問題
#
#   # モデル側の authenticated?メソッド を 一般化する前
#
#   # # authenticated?メソッド 記憶ダイジェスト の nilガード
#   # describe "authenticated? with nil remember_digest" do
#   #   # 引数の remember_token には 適当な値をセット
#   #   let(:value) { @user.authenticated?("foo") }
#   #   it { expect(value).to be_falsey }
#   # end
#
#   # モデル側の authenticated?メソッド が 一般化された後
#
#   describe "authenticated? with nil remember_digest" do
#     let(:value) { @user.authenticated?(:remember, "foo") }
#     it { expect(value).to be_falsey }
#   end
#
#   # describe "authenticated? with nil activation_digest" do
#   #   let(:value) { @user.authenticated?(:activation, "foo") }
#   #   it { expect(value).to be_falsey }
#   # end
#
# end









# require 'rails_helper'
#
# RSpec.describe User, type: :model do
#
#   before do
#     @user = User.new(name: "Example User",
#                      email: "user@example.com",
#                      password: "foobar",
#                      password_confirmation: "foobar")
#   end
#   subject { @user }
#
#   it { should respond_to(:name) }
#   it { should respond_to(:email) }
#   it { should respond_to(:password_digest) }
#   it { should respond_to(:password) }
#   it { should respond_to(:password_confirmation) }
#   it { should respond_to(:authenticate) }
#   it { should respond_to(:remember_digest) }
#   it { should respond_to(:admin) }
#
#   it { should be_valid }
#   it { should_not be_admin }
#
#   # :name
#
#   describe "when name is not present" do
#     before { @user.name = "   " }
#     it { should_not be_valid }
#   end
#
#   describe "when name is too long" do
#     before { @user.name = "a" * 51 }
#     it { should_not be_valid }
#   end
#
#   # :email
#
#   describe "when email is not present" do
#     before { @user.email = "   " }
#     it { should_not be_valid }
#   end
#
#   describe "when email is too long" do
#     before { @user.email = "a" * 255 + "@example.com" }
#     it { should_not be_valid }
#   end
#
#   describe "when email format is invalid" do
#     it "should be invalid" do
#       addresses = %w[user@foo,com user_at_foo.org example.user@foo.
#                        foo@bar_baz.com foo@bar+baz.com]
#       addresses.each do |invalid_email|
#         @user.email = invalid_email
#         expect(@user).not_to be_valid
#       end
#     end
#   end
#
#   describe "when email format is valid" do
#     it "should be valid" do
#       addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
#       addresses.each do |valid_email|
#         @user.email = valid_email
#         expect(@user).to be_valid
#       end
#     end
#   end
#
#   describe "when email address is already taken" do
#     before do
#       same_email_user = @user.dup
#       same_email_user.email = @user.email.upcase
#       same_email_user.save
#     end
#     it { should_not be_valid }
#   end
#
#   describe "when email address is mixed-case" do
#     let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
#
#     it "should be saved as lower-case" do
#       @user.email = mixed_case_email
#       @user.save
#       expect(@user.reload.email).to eq mixed_case_email.downcase
#     end
#   end
#
#   # :password
#
#   describe "when password is not present" do
#     before { @user.password = @user.password_confirmation =  "  " }
#     it { should_not be_valid }
#   end
#
#   describe "when password is too short" do
#     before { @user.password = @user.password_confirmation = "a" * 5 }
#     it { should_not be_valid }
#   end
#
#   describe "when password doesn't match confirmation" do
#     before { @user.password_confirmation = "mismatch" }
#     it { should_not be_valid }
#   end
#
#   # :authenticate
#
#   describe "returen value of authenticate method" do
#     before { @user.save }
#     let(:found_user) { User.find_by(email: @user.email) }
#
#     context "with valid password" do
#       it { should eq found_user.authenticate(@user.password) }
#     end
#     context "with invalid password" do
#       let(:user_invalid_pwd) { found_user.authenticate("invalid") }
#
#       it { should_not eq user_invalid_pwd }
#       it { expect(user_invalid_pwd).to be_falsey }
#     end
#   end
#
#   # ダイジェストが存在しない場合のauthenticated?のテスト
#   describe "authenticated? with nil digest" do
#     let(:value) { @user.authenticated?("") }
#     it { expect(value).to be_falsey }
#   end
#
#   # admin
#   describe "with admin attribute set to 'true'" do
#     before do
#       @user.save!
#       @user.toggle!(:admin)
#     end
#     it { should be_admin }
#   end
# end
