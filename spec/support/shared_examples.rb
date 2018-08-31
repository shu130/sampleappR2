                      # shared_examples

        # 共通：
        # フィーチャースペック／コントローラスペック

  # flash
  # flash[:success]
  shared_examples_for "success flash" do |msg|
    it { subject.call; expect(flash[:success]).to eq msg }
  end

  # def success_flash(msg)
  #   expect(page).to have_css("div.alert.alert-success", text: msg)
  # end

  # shared_examples_for "success messages" do |msg|
  #   it { expect(page).to have_css("div.alert.alert-success", text: msg) }
  # end
  # => it_behaves_like "success messages", msg

  # flash[:danger]
  shared_examples_for "error flash" do |msg|
    it { subject.call; expect(flash[:danger]).to eq msg }
  end

  # redirect to path
  shared_examples_for "redirect to path" do |path|
    it { subject.call; expect(response).to redirect_to path }
  end


                      # コントローラスペック

  # assigns
  shared_examples_for "assigned @value is equal value" do |value|
    it { subject.call; expect(value).to eq value }
  end
  # http status
  shared_examples_for "returns http status" do |status|
    it { subject.call; expect(response).to have_http_status(status) }
  end
  # render template
  shared_examples_for "render template" do |template|
    it { subject.call; expect(response).to render_template template }
  end

  # model
  # create/update/delete
  # create
  shared_examples_for "create data (increment:1)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(1) } # or
    # it { expect{ subject.call }.to change{ model.count }.by(1) }
  end
  # update
  shared_examples_for "update data (increment:0)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(0) }
  end
  # delete
  shared_examples_for "delete data (increment:-1)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(-1) }
  end
  # not change case
  shared_examples_for "not change data (increment:0)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(0) }
  end


                        # フィーチャスペック

                        # リンク
  # links
  # users#show
  shared_examples_for "have links of profile-page" do
    it { expect(page).to have_link("Users",    href: "/users") }
    it { expect(page).to have_link("Profile",  href: user_path(user)) }
    it { expect(page).to have_link("Settings", href: edit_user_path(user)) }
    it { expect(page).to have_link("Log out",  href: "/logout") }
    it { expect(page).not_to have_link("Log in",  href: "/login") }
  end

  # user_info
  # top#home, users#following, users#followers
  shared_examples_for "have user infomation" do
    it { expect(page).to have_css('img.gravatar') }
    it { expect(page).to have_css('h1', text: user.name) }
    it { expect(page).to have_text("microposts") }
    it { expect(page).to have_link("view my profile", href: user_path(user)) }
  end
  # users#show
  shared_examples_for "have user profile infomation" do
    it { expect(page).to have_css('img.gravatar') }
    it { expect(page).to have_css('h1', text: user.name) }
  end

  # microposts_stats
  # tops#home, users#show
  shared_examples_for "have link user's following/followers" do
    it { expect(page).to have_link("following", href: following_user_path(user)) }
    it { expect(page).to have_link("followers", href: followers_user_path(user)) }
  end

                    # フォーム

  # signup form
  # users#new
  shared_examples_for "signup-form have right css" do
    it { expect(page).to have_css('label', text: 'Name') }
    it { expect(page).to have_css('label', text: 'Email') }
    it { expect(page).to have_css('label', text: 'Password') }
    it { expect(page).to have_css('label', text: 'Confirmation') }
    it { expect(page).to have_css('input#user_name') }
    it { expect(page).to have_css('input#user_email') }
    it { expect(page).to have_css('input#user_password') }
    it { expect(page).to have_css('input#user_password_confirmation') }
    it { expect(page).to have_button('Create my account') }
  end

  # login form
  # sessions#new
  shared_examples_for "login-form have right css" do
    it { expect(page).to have_css('label', text: 'Email') }
    it { expect(page).to have_css('label', text: 'Password') }
    it { expect(page).to have_css('input#session_email') }
    it { expect(page).to have_css('input#session_password') }
    it { expect(page).to  have_css('input#session_remember_me[type="checkbox"]') }
    it { expect(page).to have_css('label.checkbox.inline', text: 'Remember me') }
    it { expect(page).to have_button('Log in') }
  end

  # microposts form
  # tops#home
  shared_examples_for "micropost-form have right css" do
    it { expect(page).to have_css('textarea#micropost_content') }
    it { expect(page).to have_css('input#micropost_picture') }
    it { expect(page).to have_button('Post') }
  end


                  # ユーザの作成／削除

  # ユーザの作成（一般ユーザ）
  # user
  # users#create
  # success
  shared_examples_for "success create user" do
    scenario "user increment 1" do
      expect {
        visit signup_path
        fill_in_signup_form(:user) # => SupportModule を使用
        click_button "Create my account"
      }.to change(User, :count).by(1)
      # 成功メッセージ
      expect(page).to have_css("div.alert.alert-success", text: "Welcome to the Sample App!")
      # profile-page へリダイレクトすること
      expect(page).to have_current_path(user_path(User.last))
      expect(current_path).to eq user_path(User.last)
    end
  end
  # fail
  shared_examples_for "fail create user" do
    scenario "user increment 0" do
      expect {
        visit signup_path
        fill_in_signup_form(:user, invalid: true) # => SupportModule を使用
        click_button "Create my account"
      }.to change(User, :count).by(0)
      # 失敗メッセージ
      expect(page).to have_css('div.alert.alert-danger', text: "errors")
      # サインアップページのまま
      # expect(page).to have_current_path("/signup")
      # expect(current_path).to eq user_path("/signup")
      expect(page).to have_title("Sign up")
      expect(page).to have_css("h1", text: "Sign up")
    end
  end

  # ユーザの削除（admin権限）
  # users#destroy
  # success
  shared_examples_for "success delete user" do
    # before { users }
    scenario "user decrememt -1" do
      login_as(admin)
      click_link "Users"
      expect(page).to have_current_path("/users")
      expect(page).to have_link('delete', href: user_path(User.first))
      expect(page).to have_link('delete', href: user_path(User.second))
      expect(page).not_to have_link('delete', href: user_path(admin))
      # expect {
      #   subject.call
      # }.to change(User, :count).by(-1)
      expect {
        click_link('delete', match: :first)
        expect(page).to have_css("div.alert.alert-success", text: "User deleted")
      }.to change(User, :count).by(-1)
    end
  end
  # fail
  shared_examples_for "fail delete user" do
    scenario "user decrement 0" do
      login_as(user)
      click_link "Users"
      expect(page).to have_current_path("/users")
      expect(page).not_to have_link('delete', href: user_path(User.first))
      expect(page).not_to have_link('delete', href: user_path(User.second))
      expect {
        # リンクが無いので、直接 HTTPリクエストを発行
        delete user_path(User.first)
        # expect(response).to redirect_to "/"
        # subject.call
      }.to change(User, :count).by(0)
    end
  end

                  # マイクロポストの作成／削除
  # micropost
  # microposts#create
  # success
  shared_examples_for "success create micropost" do
    scenario "micropost increment 1" do
      expect {
        visit root_path
        params = post_params
        fill_in "micropost_content", with: params[:content]
        click_button "Post"
      }.to change(Micropost, :count).by(1)
      # 成功メッセージ
      expect(page).to have_css("div.alert.alert-success", text: "Micropost created")
    end
  end
  # fail
  shared_examples_for "fail create micropost" do
    scenario "micropost increment 0" do
      expect {
        visit root_path
        fill_in "micropost_content", with: ""
        click_button "Post"
      }.to change(Micropost, :count).by(0)
      # 失敗メッセージ
      expect(page).to have_css("div.alert.alert-danger")
    end
  end
  # micropost
  # microposts#destroy
  # success
  shared_examples_for "success delete micropost" do
    before { my_posts }
    scenario "micropost descrement -1" do
      expect {
        visit root_path
        click_link "delete", match: :first
        # expect { success_flash("Micropost deleted") }
      }.to change(Micropost, :count).by(-1)
      # 成功メッセージ
      expect(page).to have_css("div.alert.alert-success", text: "Micropost deleted")
    end
  end
  # fail
  shared_examples_for "fail delete micropost" do
    before { other_posts }
    # subject { Proc.new { delete micropost_path(other_posts.first.id) } }
    scenario "micropost descrement 0" do
      expect {
        # リンクが無いので、直接 HTTPリクエストを発行
        delete micropost_path(other_posts.first.id)
        # subject.call
      }.to change(User, :count).by(0)
      # # ルートにリダイレクトされていること
      # expect(page).to have_current_path("/")
    end
    # scenario "redirect to root_url" do
    #   subject.call; expect(response).to redirect_to "/"
    # end
  end




                      # モデルスペック

# Userモデル

  shared_examples_for "User-model respond to attribute or method" do
    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:authenticate) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:remember_digest) }
    it { should respond_to(:activation_digest) }
    it { should respond_to(:admin) }
    it { should respond_to(:microposts) }
    it { should respond_to(:feed) }
    # it { should respond_to(:relationships) }
    it { should respond_to(:active_relationships) }
    it { should respond_to(:passive_relationships) }
    it { should respond_to(:following) }
    it { should respond_to(:followers) }
    it { should respond_to(:follow) }
    it { should respond_to(:unfollow) }
    it { should respond_to(:following?) }
  end

  # ボツ
  # shared_examples_for "non-presence" do |attr|
  #   before { user.attr = "   " }
  #   # attr = "   "
  #   it { expect{ subject.call }; not_to be_valid }
  # end

# Micropostモデル

  shared_examples_for "Micropost-model respond to attribute or method" do
    it { should respond_to(:content) }
    it { should respond_to(:user_id) }
    # it { expect(page).to respond_to(:content) }
    # it { expect(page).to respond_to(:user_id) }
  end

# # Relationshipモデル
#
#   shared_examples_for "Relationship-model respond to attribute or method" do
#     it { should respond_to(:follower) }
#     it { should respond_to(:followed) }
#     # its(:follower) { expect(page).to eq follower }
#     # its(:followed) { expect(page).to eq followed }
#
#   end














#                       # shared_examples
#
#         # 共通：
#         # フィーチャースペック／コントローラスペック
#
#   # flash
#   # flash[:success]
#   shared_examples_for "success flash" do |msg|
#     it { subject.call; expect(flash[:success]).to eq msg }
#   end
#
#   # def success_flash(msg)
#   #   expect(page).to have_css("div.alert.alert-success", text: msg)
#   # end
#
#   shared_examples_for "success messages" do |msg|
#     it { expect(page).to have_css("div.alert.alert-success", text: msg) }
#   end
#   # => it_behaves_like "success messages", msg
#
#   # flash[:danger]
#   shared_examples_for "error flash" do |msg|
#     it { subject.call; expect(flash[:danger]).to eq msg }
#   end
#
#   # redirect to path
#   shared_examples_for "redirect to path" do |path|
#     it { subject.call; expect(response).to redirect_to path }
#   end
#
#
#                       # コントローラスペック
#
#   # assigns
#   shared_examples_for "assigned @value is equal value" do |value|
#     it { subject.call; expect(value).to eq value }
#   end
#   # http status
#   shared_examples_for "returns http status" do |status|
#     it { subject.call; expect(response).to have_http_status(status) }
#   end
#   # render template
#   shared_examples_for "render template" do |template|
#     it { subject.call; expect(response).to render_template template }
#   end
#
#   # model
#   # create/update/delete
#   # create
#   shared_examples_for "create data (increment:1)" do |model|
#     it { expect{ subject.call }.to change(model, :count).by(1) } # or
#     # it { expect{ subject.call }.to change{ model.count }.by(1) }
#   end
#   # update
#   shared_examples_for "update data (increment:0)" do |model|
#     it { expect{ subject.call }.to change(model, :count).by(0) }
#   end
#   # delete
#   shared_examples_for "delete data (increment:-1)" do |model|
#     it { expect{ subject.call }.to change(model, :count).by(-1) }
#   end
#   # not change case
#   shared_examples_for "not change data (increment:0)" do |model|
#     it { expect{ subject.call }.to change(model, :count).by(0) }
#   end
#
#
#                         # フィーチャスペック
#
#                         # リンク
#   # links
#   # users#show
#   shared_examples_for "have links of profile-page" do
#     it { expect(page).to have_link("Users",    href: "/users") }
#     it { expect(page).to have_link("Profile",  href: user_path(user)) }
#     it { expect(page).to have_link("Settings", href: edit_user_path(user)) }
#     it { expect(page).to have_link("Log out",  href: "/logout") }
#     it { expect(page).not_to have_link("Log in",  href: "/login") }
#   end
#
#   # user_info
#   # top#home, users#following, users#followers
#   shared_examples_for "have user infomation" do
#     it { expect(page).to have_css('img.gravatar') }
#     it { expect(page).to have_css('h1', text: user.name) }
#     it { expect(page).to have_text("Microposts") }
#     it { expect(page).to have_link("view my profile", href: user_path(user)) }
#   end
#   # users#show
#   shared_examples_for "have user profile infomation" do
#     it { expect(page).to have_css('img.gravatar') }
#     it { expect(page).to have_css('h1', text: user.name) }
#   end
#
#   # microposts_stats
#   # tops#home, users#show
#   shared_examples_for "have link user's following/followers" do
#     it { expect(page).to have_link("following", href: following_user_path(user)) }
#     it { expect(page).to have_link("followers", href: followers_user_path(user)) }
#   end
#
#                     # フォーム
#
#   # signup form
#   # users#new
#   shared_examples_for "signup-form have right css" do
#     it { expect(page).to have_css('label', text: 'Name') }
#     it { expect(page).to have_css('label', text: 'Email') }
#     it { expect(page).to have_css('label', text: 'Password') }
#     it { expect(page).to have_css('label', text: 'Confirmation') }
#     it { expect(page).to have_css('input#user_name') }
#     it { expect(page).to have_css('input#user_email') }
#     it { expect(page).to have_css('input#user_password') }
#     it { expect(page).to have_css('input#user_password_confirmation') }
#     it { expect(page).to have_button('Create my account') }
#   end
#
#   # login form
#   # sessions#new
#   shared_examples_for "login-form have right css" do
#     it { expect(page).to have_css('label', text: 'Email') }
#     it { expect(page).to have_css('label', text: 'Password') }
#     it { expect(page).to have_css('input#session_email') }
#     it { expect(page).to have_css('input#session_password') }
#     it { expect(page).to  have_css('input#session_remember_me[type="checkbox"]') }
#     it { expect(page).to have_css('label.checkbox.inline', text: 'Remember me') }
#     it { expect(page).to have_button('Log in') }
#   end
#
#   # microposts form
#   # tops#home
#   shared_examples_for "micropost-form have right css" do
#     it { expect(page).to have_css('textarea#micropost_content') }
#     it { expect(page).to have_css('input#micropost_picture') }
#     it { expect(page).to have_button('Post') }
#   end
#
#
#                   # ユーザの作成／削除
#
#   # ユーザの作成（一般ユーザ）
#   # user
#   # users#create
#   # success
#   shared_examples_for "success create user" do
#     scenario "user increment 1" do
#       expect {
#         visit signup_path
#         fill_in_signup_form(:user)
#         click_button "Create my account"
#       }.to change(User, :count).by(1)
#     end
#   end
#   # fail
#   shared_examples_for "fail create user" do
#     scenario "user increment 0" do
#       expect {
#         visit signup_path
#         fill_in_signup_form(:user, invalid: true)
#         click_button "Create my account"
#       }.to change(User, :count).by(0)
#     end
#   end
#   # ユーザの削除（admin権限）
#   # users#destroy
#   # success
#   shared_examples_for "success delete user" do
#     before { users }
#     scenario "user decrememt -1" do
#       login_as(admin)
#       click_link "Users"
#       expect(page).to have_current_path("/users")
#       expect(page).to have_link('delete', href: user_path(User.first))
#       expect(page).to have_link('delete', href: user_path(User.second))
#       expect(page).not_to have_link('delete', href: user_path(admin))
#       expect {
#         click_link('delete', match: :first)
#       }.to change(User, :count).by(-1)
#     end
#   end
#   # fail
#   shared_examples_for "fail delete user" do
#     scenario "user decrement 0" do
#       login_as(user)
#       click_link "Users"
#       expect(page).to have_current_path("/users")
#       expect(page).not_to have_link('delete', href: user_path(User.first))
#       expect(page).not_to have_link('delete', href: user_path(User.second))
#       expect {
#         # リンクが無いので、直接 HTTPリクエストを発行
#         delete user_path(User.first)
#         # expect(response).to redirect_to "/"
#         # subject.call
#       }.to change(User, :count).by(0)
#     end
#   end
#
#                   # マイクロポストの作成／削除
#   # micropost
#   # microposts#create
#   # success
#   shared_examples_for "success create micropost" do
#     scenario "micropost increment 1" do
#       expect {
#         visit root_path
#         params = post_params
#         fill_in "micropost_content", with: params[:content]
#         click_button "Post"
#       }.to change(Micropost, :count).by(1)
#     end
#   end
#   # fail
#   shared_examples_for "fail create micropost" do
#     scenario "micropost increment 0" do
#       expect {
#         visit root_path
#         fill_in "micropost_content", with: ""
#         click_button "Post"
#       }.to change(Micropost, :count).by(0)
#     end
#   end
#   # micropost
#   # microposts#destroy
#   # success
#   shared_examples_for "success delete micropost" do
#     before { my_posts }
#     scenario "micropost descrement -1" do
#       expect {
#         visit root_path
#         click_link "delete", match: :first
#         # expect { success_flash("Micropost deleted") }
#       }.to change(Micropost, :count).by(-1)
#     end
#   end
#   # fail
#   shared_examples_for "fail delete micropost" do
#     before { other_posts }
#     # subject { Proc.new { delete micropost_path(other_posts.first.id) } }
#     scenario "micropost descrement 0" do
#       expect {
#         # リンクが無いので、直接 HTTPリクエストを発行
#         delete micropost_path(other_posts.first.id)
#         # subject.call
#       }.to change(User, :count).by(0)
#     end
#     # scenario "redirect to root_url" do
#     #   subject.call; expect(response).to redirect_to "/"
#     # end
#   end
#
#
#
#
#                       # モデルスペック
#
# # Userモデル
#
#   shared_examples_for "User-model respond to attribute or method" do
#     it { expect(page).to respond_to(:name) }
#     it { expect(page).to respond_to(:email) }
#     it { expect(page).to respond_to(:password) }
#     it { expect(page).to respond_to(:password_confirmation) }
#     it { expect(page).to respond_to(:authenticate) }
#     it { expect(page).to respond_to(:password_digest) }
#     it { expect(page).to respond_to(:remember_digest) }
#     it { expect(page).to respond_to(:activation_digest) }
#     it { expect(page).to respond_to(:admin) }
#     it { expect(page).to respond_to(:microposts) }
#     it { expect(page).to respond_to(:feed) }
#     # it { expect(page).to respond_to(:relationships) }
#     it { expect(page).to respond_to(:active_relationships) }
#     it { expect(page).to respond_to(:passive_relationships) }
#     it { expect(page).to respond_to(:following) }
#     it { expect(page).to respond_to(:followers) }
#     it { expect(page).to respond_to(:follow) }
#     it { expect(page).to respond_to(:unfollow) }
#     it { expect(page).to respond_to(:following?) }
#   end
#
#   # ボツ
#   # shared_examples_for "non-presence" do |attr|
#   #   before { user.attr = "   " }
#   #   # attr = "   "
#   #   it { expect{ subject.call }; not_to be_valid }
#   # end
#
# # Micropostモデル
#
#   shared_examples_for "Micropost-model respond to attribute or method" do
#     it { expect(page).to respond_to(:content) }
#     it { expect(page).to respond_to(:user_id) }
#   end
#
# # Relationshipモデル
#
#   shared_examples_for "Relationship-model respond to attribute or method" do
#     it { expect(page).to respond_to(:follower) }
#     it { expect(page).to respond_to(:followed) }
#     # its(:follower) { expect(page).to eq follower }
#     # its(:followed) { expect(page).to eq followed }
#
#   end
#













#                       # shared_examples
#
#                       # コントローラスペック or
#                       # フィーチャスペック
#
#   # assigns
#   shared_examples_for "assigned @value is equal value" do |value|
#     it { subject.call; expect(value).to eq value }
#   end
#   # http status
#   shared_examples_for "returns http status" do |status|
#     it { subject.call; expect(response).to have_http_status(status) }
#   end
#   # render template
#   shared_examples_for "render template" do |template|
#     it { subject.call; expect(response).to render_template template }
#   end
#   # redirect to path
#   shared_examples_for "redirect to path" do |path|
#     it { subject.call; expect(response).to redirect_to path }
#   end
#
#   # # current path
#   # shared_examples_for "current path" do |path|
#   #   it { subject.call; expect(page).to have_current_path path }
#   # end
#
#   # flash
#   # flash[:success]
#   shared_examples_for "success message" do |msg|
#     it { subject.call; expect(flash[:success]).to eq msg }
#   end
#   # flash[:danger]
#   shared_examples_for "error message" do |msg|
#     it { subject.call; expect(flash[:danger]).to eq msg }
#   end
#
#   # # ↓ なぜかNG
#   # # error
#   # shared_examples_for "have error 'can't be blank'" do |attribute|
#   #   it { subject.call; expect(other_user.errors[attribute]).to include "can't be blank" }
#   # end
#
#   # おまけ
#   # ページタイトル
#   shared_examples_for "pages expect(page).to have title" do |page_title|
#     let(:base_title) { "Ruby on Rails Tutorial Sample App" }
#     if page_title == "Home"
#       it { subject.call; expect(response.body).to include "#{base_title}" }
#       # it { subject.call; expect(response.body).to include "base_title" }
#     else
#       it { subject.call; expect(response.body).to include "#{page_title} | #{base_title}" }
#       # it { subject.call; expect(response.body).to include "page_title | base_title" }
#     end
#   end
#
#   # model
#   # create/update/delete
#   # create
#   shared_examples_for "create data (increment:1)" do |model|
#     it { expect{ subject.call }.to change(model, :count).by(1) } # or
#     # it { expect{ subject.call }.to change{ model.count }.by(1) }
#   end
#   # update
#   shared_examples_for "update data (increment:0)" do |model|
#     it { expect{ subject.call }.to change(model, :count).by(0) }
#   end
#   # delete
#   shared_examples_for "delete data (increment:-1)" do |model|
#     it { expect{ subject.call }.to change(model, :count).by(-1) }
#   end
#   # not change case
#   shared_examples_for "not change data (increment:0)" do |model|
#     it { expect{ subject.call }.to change(model, :count).by(0) }
#   end
#
#
#
#                       # モデルスペック
#
# # Userモデル
#
#   shared_examples_for "User-model respond to attribute or method" do
#     it { expect(page).to respond_to(:name) }
#     it { expect(page).to respond_to(:email) }
#     it { expect(page).to respond_to(:password) }
#     it { expect(page).to respond_to(:password_confirmation) }
#     it { expect(page).to respond_to(:authenticate) }
#     it { expect(page).to respond_to(:password_digest) }
#     it { expect(page).to respond_to(:remember_digest) }
#     it { expect(page).to respond_to(:activation_digest) }
#     it { expect(page).to respond_to(:admin) }
#     it { expect(page).to respond_to(:microposts) }
#     it { expect(page).to respond_to(:feed) }
#     # it { expect(page).to respond_to(:relationships) }
#     it { expect(page).to respond_to(:active_relationships) }
#     it { expect(page).to respond_to(:passive_relationships) }
#     it { expect(page).to respond_to(:following) }
#     it { expect(page).to respond_to(:followers) }
#     it { expect(page).to respond_to(:follow) }
#     it { expect(page).to respond_to(:unfollow) }
#     it { expect(page).to respond_to(:following?) }
#   end
#
#   # ボツ
#   # shared_examples_for "non-presence" do |attr|
#   #   before { user.attr = "   " }
#   #   # attr = "   "
#   #   it { expect{ subject.call }; not_to be_valid }
#   # end
#
# # Micropostモデル
#
#   shared_examples_for "Micropost-model respond to attribute or method" do
#     it { expect(page).to respond_to(:content) }
#     it { expect(page).to respond_to(:user_id) }
#   end
#
# # Relationshipモデル
#
#   shared_examples_for "Relationship-model respond to attribute or method" do
#     it { expect(page).to respond_to(:follower) }
#     it { expect(page).to respond_to(:followed) }
#     # its(:follower) { expect(page).to eq follower }
#     # its(:followed) { expect(page).to eq followed }
#
#   end
#
