include ApplicationHelper

# def full_title(page_title = "")
#   base_title = "Ruby on Rails Tutorial Sample App"
#   if page_title.empty?
#     base_title
#   else
#     "#{page_title} | #{base_title}"
#   end
# end


# def log_in_as(user)
#   session[:user_id] = user.id
# end
#
# def log_in_as(user, password: 'password', remember_me: '1')
#   post login_path, params: { session: { email: user.email,
#                                         password: password,
#                                         remember_me: remember_me } }
# end

# class ActionDispatch::IntegrationTest
#   def log_in_as(user, password: 'password', remember_me: '1')
#     post login_path, params: { session: { email: user.email,
#                                           password: password,
#                                           remember_me: remember_me } }
#   end
# end

# def test_login(user)
#   visit login_path
#   fill_in "Email",    with: user.email
#   fill_in "Password", with: user.password
#   click_button "Log in"
#   # cookies[:remember_token] = User.new_token
# end

# def valid_login(user)
  # visit login_path
  # fill_in "Email",    with: user.email
  # fill_in "Password", with: user.password
  # click_button "Log in"
# end

# chap09
# def valid_login_no_capybara
#   remember_token = User.new_remember_token
#   cookies[:remember_token] = remember_token
#   user.update_attribute(:remember_token, User.encrypt(remember_token))
# end

# def cookie(key)
#   page.driver.browser.rack_mock_session.cookie_jar[key]
# end

# def log_in_as(user, password: user.password, remember_me: '1')
#   post login_path, params: { session: { email: user.email,
#                                         password: password,
#                                         remember_me: remember_me } }
# end



# # chap09
# def test_login_no_capybara(user)
#   # app/models/user.rb
#   #   remember_in_db
#   remember_token = User.new_token
#   user.update_attribute(:remember_digest, User.digest(remember_token))
#   # app/helpers/sessions_helper.rb
#   #   remember_in_db_ck
#   cookies.signed[:user_id] = user.id
#   cookies[:remember_token] = remember_token
# end
#

# def is_logged_in?
#   !session[:user_id].nil?
# end
#
# def log_in_as(user)
#   session[:user_id] = user.id
# end

#
# # リスト9.6 ユーザーがサインインするためのテストヘルパー
# def test_login(user, options={remember_me: false, no_capybara: false})
# # def test_login(user, options={no_capybara: false})
#   if options[:no_capybara]
#     # app/models/user.rb
#     #   remember_in_db
#     remember_token = User.new_token
#     user.update_attribute(:remember_digest, User.digest(remember_token))
#     # app/helpers/sessions_helper.rb
#     #   remember_in_db_ck
#     # cookies.signed[:user_id] = user.id
#     cookies[:remember_token] = remember_token
#   else
#     visit login_path
#     fill_in "Email",    with: user.email
#     fill_in "Password", with: user.password
#     # check   'session_remember_me' if options[:remember_me]
#     click_button "Log in"
#   end
# end


# 参考もと
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
