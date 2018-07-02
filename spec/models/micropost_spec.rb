require 'rails_helper'

RSpec.describe Micropost, type: :model do

  let(:user) { create(:user) }
  let(:my_post) { build(:user_post) }
  let!(:old_post) { create(:user_post, created_at: 1.day.ago) }
  let!(:new_post) { create(:user_post, created_at: 1.hour.ago) }

  # subject { my_post }

  it_behaves_like "Micropost-model respond to attribute or method"

  # validations

  # 存在性 presence
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :content }

  # 文字数
  describe "when content is too long" do
    before { my_post.content = "a" * 141 }
    it { expect(my_post).not_to be_valid }
  end

  describe "association" do
    # 降順
    it "order descending" do
      expect(user.microposts.to_a).to eq [new_post, old_post]
    end
    # ユーザが破棄されるとマイクロポストも破棄される
    it "depends on destroy-user" do
      my_posts = user.microposts.to_a
      user.destroy
      expect(my_posts).not_to be_empty
      user.microposts.each do |post|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end


  end


end


# アウトライン
