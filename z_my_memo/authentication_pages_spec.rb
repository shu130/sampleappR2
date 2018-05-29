
# chap09
# outline

RSpec.feature "AuthenticationPages", type: :feature do

  subject { page }

  describe "login"
    context "with invalid infomation"
      context "after visit another page"
    context "with valid infomation"
      context "followed by logout"
      context "with remember_me"
      context "without remember_me"

  describe "authorization"

    context "for non-logged-in user"
      context "when attemp to visit protected page"
        describe "after login"
          it "should render desired protected page"
      context "in UsersController"
        describe "visit edit page"
        describe "submit update action"
        describe "visit user-index page"

    context "as wrong user"
      describe "submit GET Users#edit"
      describe "submit PATCH Users#update"

    context "as non-admin user"
      describe "submit DELETE Users#destroy"
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
