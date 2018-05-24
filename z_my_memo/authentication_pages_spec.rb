
# chap09
# 自分で考えた

require 'rails_helper'

RSpec.feature "AuthenticationPages", type: :feature do

  subject { page }

  describe "login"
    context "with invalid infomation"
      context "after visit another page"
    context "with valid infomation"
      context "followed by logout"
      # 追加
      context "with remember_me"
      context "without remember_me"

end




# chap08

require 'rails_helper'

RSpec.feature "AuthenticationPages", type: :feature do

  subject { page }

  describe "login"
    context "with invalid infomation"
      context "after visit another page"
    context "with valid infomation"
      context "followed by logout"


end
