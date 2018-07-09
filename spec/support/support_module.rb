module SupportModule
                      # setup_method

  def fill_in_signup_form(user, option = { invalid: false })
    if option[:invalid]
      fill_in "Name",         with: ""
      fill_in "Email",        with: ""
      fill_in "Password",     with: ""
      fill_in "Confirmation", with: ""
    else
      params = attributes_for(:user)
      fill_in "Name",         with: params[:name]
      fill_in "Email",        with: params[:email]
      fill_in "Password",     with: params[:password]
      fill_in "Confirmation", with: params[:password]
    end
  end

  def fill_in_micropost_form(user, option = { invalid: false })
    if option[:invalid]
      fill_in "micropost_content",         with: ""
    else
      params = attributes_for(:user_post)
      fill_in "micropost_content",         with: params[:content]
    end
  end

  # def fill_in_signup_valid
  #   params = attributes_for(:user)
  #   fill_in "Name",         with: params[:name]
  #   fill_in "Email",        with: params[:email]
  #   fill_in "Password",     with: params[:password]
  #   fill_in "Confirmation", with: params[:password]
  # end
  #
  # def fill_in_signup_invalid
  #   fill_in "Name",         with: ""
  #   fill_in "Email",        with: ""
  #   fill_in "Password",     with: ""
  #   fill_in "Confirmation", with: ""
  # end

  def fill_in_login_form(user, option = { invalid: false })
    if option[:invalid]
      fill_in "Email",        with: ""
      fill_in "Password",     with: ""
    else
      fill_in "Email",        with: user.email
      fill_in "Password",     with: user.password
    end
  end

  def login_as(user)
    visit root_path
    click_link "Log in"
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end

  def fill_in_update_profile_form(name, email, password = "", confirmation = "")
    fill_in "Name",         with: name
    fill_in "Email",        with: email
    fill_in "Password",     with: password
    fill_in "Confirmation", with: confirmation
    # click_button "Save changes"
  end




                      # test_method

  # subject { page } + shouldaマッチャ

  def title_heading(titile, heading = title)
    expect(page).to have_title(title)
    expect(page).to have_css("h1", text: heading) # or
    # should have_title(title)
    # should have_css("h1", text: heading) # or
    # expect(page).to have_selector("h1", text: heading) # or
    # expect(page).to have_content('h1', text: heading) # or
    # it { should have_content('All users') }
  end

  def title_heading_of_profile_page(user)
    u = User.find_by(email: user.email)
    expect(page).to have_title(u.name)
    expect(page).to have_css('h1', text: u.name) # or
    # expect(page).to have_content('h1', text: u.name)
  end
  # def title_heading_of_profile_page(user)
  #   u = User.find_by(email: user.email)
  #   should have_title(u.name)
  #   should have_css('h1', text: u.name) # or
  #   # it { should have_content('All users') }
  # end

  def current_path(path_name)
    expect(page).to have_current_path(path_name)
    # should have_current_path(path_name)
  end

  # ログインフォーム
  def login_form_css
    # should have_current_path("/login")
    should have_css('label', text: 'Email')
    should have_css('label', text: 'Password')
    should have_css('input#session_email')
    should have_css('input#session_password')
    should have_css('input#session_remember_me[type="checkbox"]')
    should have_css('label.checkbox.inline', text: 'Remember me')
    should have_button('Log in')
  end

  # マイクロポストフォーム
  def micropost_form_css
    should have_css('textarea#micropost_content')
    should have_css('input#micropost_picture')
    should have_button('Post')
  end

  def links_of_profile_page(user)
    # should have_link("Users",    href: users_path)
    should have_link("Users",    href: "/users")
    should have_link("Profile",  href: user_path(user))
    should have_link("Settings", href: edit_user_path(user))
    # should have_link("Log out",  href: logout_path)
    should have_link("Log out",  href: "/logout")
    # should_not have_link("Log in",  href: login_path)
    should_not have_link("Log in",  href: "/login")
  end

  def no_links(path_name)
    should_not have_link(path_name)
  end

  def success_flash(msg)
    should have_css("div.alert.alert-success", text: msg)
  end

  def error_flash(msg = "")
    # should have_css('div#error_explanation')
    # should have_css('div.alert.alert-danger') if msg.empty? and return
    if msg.empty?
      should have_css('div.alert.alert-danger')
    else
      should have_css('div.alert.alert-danger', text: msg)
    end
    # if msg.empty?
    #   should have_css('div.alert.alert-danger')
    #   should have_css('div#error_explanation')
    # else
    #   should have_css('div.alert.alert-danger', text: msg)
    # end
  end

  def no_error
    should have_css('div#error_explanation')
  end

end
