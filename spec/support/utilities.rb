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

def log_in_as(user)
  session[:user_id] = user.id
end

def log_in_as(user, password: 'password', remember_me: '1')
  post login_path, params: { session: { email: user.email,
                                        password: password,
                                        remember_me: remember_me } }
end
