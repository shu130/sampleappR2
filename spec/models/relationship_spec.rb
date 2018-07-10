require 'rails_helper'

RSpec.describe Relationship, type: :model do

  # validations

  # 存在性 presence
  it { is_expected.to validate_presence_of :followed_id }
  it { is_expected.to validate_presence_of :follower_id }


end
