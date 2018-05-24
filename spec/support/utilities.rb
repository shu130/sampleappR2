include ApplicationHelper

# def full_title(page_title = "")
#   base_title = "Ruby on Rails Tutorial Sample App"
#   if page_title.empty?
#     base_title
#   else
#     "#{page_title} | #{base_title}"
#   end
# end

def valid_login(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end
