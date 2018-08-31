require 'rails_helper'

RSpec.describe Relationship, type: :model do

  let(:user) { create(:user) }             # => フォローしているユーザ
  let(:other_user) { create(:other_user) } # => フォローされているユーザ
  let(:active) { user.active_relationships.build(followed_id: other_user.id) }
  subject { active }

  # リレーションシップが有効であること
  it { should be_valid }
  # it { expect(active).to be_valid }

  # it_behaves_like "Relationship-model respond to attribute or method"

  # follow/followedメソッド
  describe "follower/followed methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    # followメソッドは、フォローしているユーザを返すこと
    it "follower method return following-user" do
      expect(active.follower). to eq user
    end
    # it { expect(active.follower). to eq user }
    # followerメソッドは、フォローされているユーザを返すこと
    it "followed method return followed-user" do
      expect(active.followed). to eq other_user
    end
    # it { expect(active.followed). to eq other_user }
    # or
    # its(:follower) { should eq user }
    # its(:followed) { should eq other_user }
  end

  # validations
  describe "validations" do
    # 存在性 presence
    describe "presence" do
      it { is_expected.to validate_presence_of :followed_id }
      it { is_expected.to validate_presence_of :follower_id }
    end
  end
end


# irb(main):008:0* active = user.active_relationships.build(followed_id: other_user.id)
# => #<Relationship id: nil, follower_id: 101, followed_id: 102, created_at: nil, updated_at: nil>
