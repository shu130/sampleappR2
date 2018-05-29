
# chap09

# ログイン
# 無効 な ログイン の場合
# ページを移動した 場合
# 無効 な ログイン の場合
# ログアウト した 場合
# ログイン記憶 が 有り の場合
# ログイン記憶 が 無し の場合
# 認証（アクセス権）
# ログイン 無し の場合
# 保護されたページ に 遷移 の場合
# ログイン 済み となった後 の場合
# 遷移しようとしたページ へ 遷移できること
# ユーザ情報 の 編集ページ に 遷移しようとした場合
# ユーザ情報 を 更新 しようとした場合
# ユーザ の 一覧ページ に 遷移しようとした場合
# ログイン済みで、他ユーザに アクセスしようとした場合
# 編集ページ に 遷移しようとした場合
# 更新 しようとした場合
# 非管理者ユーザ が ログインした場合
# ユーザ情報を 削除 しようとした場合
# 管理者ユーザ が ログインした場合
# ユーザ情報を 削除 しようとした場合


# chap09
# outline

RSpec.feature "AuthenticationPages", type: :feature do

  subject { page }

  # ログイン
  describe "login"
    # 無効 な ログイン の場合
    context "with invalid infomation"
      # ページを移動した 場合
      context "after visit another page"
    # 無効 な ログイン の場合
    context "with valid infomation"
      # ログアウト した 場合
      context "followed by logout"
      # ログイン記憶 が 有り の場合
      context "with remember_me"
      # ログイン記憶 が 無し の場合
      context "without remember_me"

  # 認証（アクセス権）
  describe "authorization"
    # ログイン 無し の場合
    context "for non-logged-in user"
      # 保護されたページ に 遷移 の場合
      context "when attemp to visit protected page"
        # ログイン 済み となった後 の場合
        describe "after login"
          # 遷移しようとしたページ へ 遷移できること
          it "should render desired protected page"
      # Usersコントローラ内 において
      context "in UsersController"
        # ユーザ情報 の 編集ページ に 遷移しようとした場合
        describe "visit edit page"
        # ユーザ情報 を 更新 しようとした場合
        describe "submit update action"
        # ユーザ の 一覧ページ に 遷移しようとした場合
        describe "visit user-index page"

    # ログイン済みで、他ユーザに アクセスしようとした場合
    context "as wrong user"
      # 編集ページ に 遷移しようとした場合
      describe "submit GET Users#edit"
      # 更新 しようとした場合
      describe "submit PATCH Users#update"

    # 非管理者ユーザ が ログインした場合
    context "as non-admin user"
      # ユーザ情報を 削除 しようとした場合
      describe "submit DELETE Users#destroy"

    # 管理者ユーザ が ログインした場合
      # ユーザ情報を 削除 しようとした場合
end
