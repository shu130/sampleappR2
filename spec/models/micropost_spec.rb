require 'rails_helper'

RSpec.describe Micropost, type: :model do

  # let(:user) { create(:user) }
  # let!(:old_post) { create(:user_post, created_at: 1.day.ago) }
  # let!(:new_post) { create(:user_post, created_at: 1.hour.ago) }

  let(:user) { create(:user) }
  # インスタンス変数(user)を明示的に渡して重複しないようにする
  subject(:my_post) { build(:user_post, user: user) }
  # let(:my_post) { build(:user_post) }
  # subject { my_post }

  # my_post が有効であること
  it { should be_valid }
  # 属性／メソッドの応答があること
  it_behaves_like "Micropost-model respond to attribute or method"

  # userメソッドは マイクロポストを作成したユーザを返すこと
  it "user method return owner of microposts" do
    expect(my_post.user).to eq user
  end

  # validations
  describe "validations" do
    # 存在性 presence
    describe "presence" do
      it { is_expected.to validate_presence_of :user_id }
      it { is_expected.to validate_presence_of :content }
    end
    # 文字数 characters
    describe "characters" do
      it { should validate_length_of(:content).is_at_most(140) }
    end

    # # 文字数 characters
    # describe "when content is too long" do
    #   before { my_post.content = "a" * 141 }
    #   it { should_not_to be_valid }
    #   # it { expect(my_post).not_to be_valid }
    # end
  end
end




# require 'rails_helper'
#
# RSpec.describe Micropost, type: :model do
#
#   let(:user) { create(:user) }
#   let(:my_post) { build(:user_post) }
#   let!(:old_post) { create(:user_post, created_at: 1.day.ago) }
#   let!(:new_post) { create(:user_post, created_at: 1.hour.ago) }
#
#   subject { my_post }
#
#   it { should be_valid }
#   it_behaves_like "Micropost-model respond to attribute or method"
#
#   # validations
#   describe "validations" do
#     # 存在性 presence
#     it { is_expected.to validate_presence_of :user_id }
#     it { is_expected.to validate_presence_of :content }
#
#     # 文字数 characters
#     describe "when content is too long" do
#       before { my_post.content = "a" * 141 }
#       it { expect(my_post).not_to be_valid }
#     end
#   end
#
#   describe "micropost" do
#     # 降順
#     it "order descending" do
#       expect(user.microposts.to_a).to eq [new_post, old_post]
#     end
#     # ユーザが破棄されるとマイクロポストも破棄される
#     it "depends on destroy-user" do
#       my_posts = user.microposts.to_a
#       user.destroy
#       expect(my_posts).not_to be_empty
#       user.microposts.each do |post|
#         expect(Micropost.where(id: micropost.id)).to be_empty
#       end
#     end
#     # マイクロポストフィード
#     describe "micropost feed" do
#       # let(:user) { create(:user) }
#       let(:followed_user) { create(:other_user) }
#       let(:unfollowed_user) { create(:other_user) }
#       before do
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
