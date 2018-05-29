include ApplicationHelper

# def full_title(page_title = "")
#   base_title = "Ruby on Rails Tutorial Sample App"
#   if page_title.empty?
#     base_title
#   else
#     "#{page_title} | #{base_title}"
#   end
# end

def test_login(user)
  visit login_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end

def valid_login(user)
  visit login_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end

# chap09
# def valid_login_no_capybara
#   remember_token = User.new_remember_token
#   cookies[:remember_token] = remember_token
#   user.update_attribute(:remember_token, User.encrypt(remember_token))
# end

# chap09
def valid_login_no_capybara(user)
  # app/models/user.rb
  #   remember_in_db
  remember_token = User.new_token
  user.update_attribute(:remember_digest, User.digest(remember_token))
  # app/helpers/sessions_helper.rb
  #   remember_in_db_ck
  cookies.signed[:user_id] = user.id
  cookies[:remember_token] = remember_token
end

# def log_in_as(user)
#   session[:user_id] = user.id
# end
#
# def log_in_as(user, password: 'password', remember_me: '1')
#   post login_path, params: { session: { email: user.email,
#                                         password: password,
#                                         remember_me: remember_me } }
# end


# リスト9.6 ユーザーがサインインするためのテストヘルパー
# def sign_in(user, options={})
#   if options[:no_capybara]
#     # Capybaraを使用していない場合にもサインインする。
#     remember_token = User.new_remember_token
#     cookies[:remember_token] = remember_token
#     user.update_attribute(:remember_token, User.encrypt(remember_token))
#   else
#     visit signin_path
#     fill_in "Email",    with: user.email
#     fill_in "Password", with: user.password
#     click_button "Sign in"
#   end
# end
