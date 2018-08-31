require 'rails_helper'

RSpec.feature "MicropostsPages", type: :feature do

  include SupportModule
  include_context "setup"

  subject { page }

  # 未ログインのテスト （before_action のテスト）
  # authorization_spec.rb にて（別ファイル）

  # マイクロポストの作成（create）
  describe "create" do
    # ログイン済みの状態で
    before { login_as(user) }
    # normal
    # valid な情報の場合
    context "valid info" do
      # 成功 (increment: 1)
      it_behaves_like "success create micropost"
    end
    # abnormal
    # invalid な情報の場合
    context "invalid info" do
      it_behaves_like "fail create micropost"
    end
  end

  # マイクロポストの削除（delete）
  describe "destroy", type: :request do
    # ログイン済みの状態で
    before { login_as(user) }
    # 自分のマイクロポストの場合
    context "attempt to delete my microposts" do
      # 成功 (decrement: -1)
      it_behaves_like "success delete micropost"
    end
    # 他人のマイクロポストの場合
    context "attempt to delete other user's microposts" do
      # 失敗 (decrement: 0)
      it_behaves_like "fail delete micropost"
    end
  end
end



# # アウトライン
# # spec/features/microposts_page_spec.rb
#
# RSpec.feature "MicropostPages", type: :feature do
#
#   # 未ログインのテスト （before_action のテスト）
#   # authorization_spec.rb にて（別ファイル）
#
#   # マイクロポストの作成（create）
#   describe "create"
#     # valid な情報の場合
#     context "valid info"
#       # 成功 (increment: 1)
#       it_behaves_like "success create micropost"
#       # 成功メッセージ
#       scenario "have success messages"
#     # invalid な情報の場合
#     context "invalid info"
#       it_behaves_like "fail create micropost"
#       # 失敗メッセージ
#       scenario "have error messages"
#     # マイクロポストの削除（delete）
#     describe "destroy"
#       # 自分のマイクロポストの場合
#       context "attempt to delete my microposts"
#         # 成功 (decrement: -1)
#         it_behaves_like "success delete micropost"
#         # successメッセージが出力されること
#         scenario "have success messages"
#       # 他人のマイクロポストの場合
#       context "attempt to delete other user's microposts"
#         # 失敗 (decrement: 0)
#         it_behaves_like "fail delete micropost"
# end





# require 'rails_helper'
#
# RSpec.feature "MicropostPages", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   # 未ログインのテスト （before_action のテスト）
#   # authorization_spec.rb にて（別ファイル）
#
#   # マイクロポストの作成（create）
#   describe "create" do
#     # ログイン済みの状態で
#     before { login_as(user) }
#     # normal
#     # valid な情報の場合
#     context "valid info" do
#       # 成功 (increment: 1)
#       it_behaves_like "success create micropost"
#       scenario "have success messages" do
#         expect { success_messages("Micropost created") }
#       end
#     end
#     # abnormal
#     # invalid な情報の場合
#     context "invalid info" do
#       it_behaves_like "fail create micropost"
#       scenario "have error messages" do
#         expect { error_messages }
#       end
#     end
#   end
#
#   # マイクロポストの削除（delete）
#   describe "destroy", type: :request do
#     # ログイン済みの状態で
#     before { login_as(user) }
#     # 自分のマイクロポストの場合
#     context "attempt to delete my microposts" do
#       # 成功 (decrement: -1)
#       it_behaves_like "success delete micropost"
#       # successメッセージが出力されること
#       scenario "have success messages" do
#         expect { success_messages("Micropost deleted") }
#       end
#     end
#     # 他人のマイクロポストの場合
#     context "attempt to delete other user's microposts" do
#       # 失敗 (decrement: 0)
#       it_behaves_like "fail delete micropost"
#     end
#   end
# end






# require 'rails_helper'
#
# RSpec.feature "MicropostPages", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   # 未ログインのテスト （before_action のテスト）
#   describe "login is necessary", type: :request do
#     context "when non-login" do
#       describe "create" do
#         subject { Proc.new { post microposts_path } }
#         it_behaves_like "error flash", "Please log in"
#         it_behaves_like "redirect to path", "/login"
#       end
#       describe "destroy" do
#         subject { Proc.new { delete micropost_path(my_post.id) } }
#         it_behaves_like "error flash", "Please log in"
#         it_behaves_like "redirect to path", "/login"
#       end
#     end
#   end
#
#   # マイクロポストの作成（create）
#   describe "create" do
#     # ログイン済みの状態で
#     before { login_as(user) }
#     # normal
#     # valid な情報の場合
#     context "valid info" do
#       # 成功 (increment: 1)
#       it_behaves_like "success create micropost"
#       scenario "have success messages" do
#         expect { success_flash("Micropost created") }
#       end
#     end
#     # abnormal
#     # invalid な情報の場合
#     context "invalid info" do
#       it_behaves_like "fail create micropost"
#       scenario "have error messages" do
#         expect { error_flash }
#       end
#     end
#   end
#
#   # マイクロポストの削除（delete）
#   describe "destroy", type: :request do
#     # ログイン済みの状態で
#     before { login_as(user) }
#     # 自分のマイクロポストの場合
#     context "attempt to delete my microposts" do
#       # 成功 (decrement: -1)
#       it_behaves_like "success delete micropost"
#       # successメッセージが出力されること
#       scenario "have success messages" do
#         expect { success_flash("Micropost deleted") }
#       end
#     end
#     # 他人のマイクロポストの場合
#     context "attempt to delete other user's microposts" do
#       # 失敗 (decrement: 0)
#       it_behaves_like "fail delete micropost"
#     end
#   end
# end



# # アウトライン
#
#   未ログインのテスト （before_action のテスト）
#     create, destroy
#       エラーメッセージ
#       ログインページヘリダイレクト
#
#   # ログイン済みの状態
#   マイクロポストの投稿（create）
#     valid な情報の場合
#       increment: 1 であること
#       successメッセージが出力されること "Micropost created"
#     invalid な情報の場合
#       increment: 0 であること
#       errrorメッセージが出力されること
#
#   マイクロポストの削除（destroy）
#     increment: -1 であること
#     successメッセージが出力されること "Micropost deleted"




# require 'rails_helper'
#
# RSpec.feature "MicropostPages", type: :feature do
#
#   include SupportModule
#   include_context "setup"
#
#   subject { page }
#
#   # 未ログインのテスト （before_action のテスト）
#   describe "login is necessary", type: :request do
#     context "when non-login" do
#       describe "create" do
#         subject { Proc.new { post microposts_path } }
#         it_behaves_like "error flash", "Please log in"
#         it_behaves_like "redirect to path", "/login"
#       end
#       describe "destroy" do
#         subject { Proc.new { delete micropost_path(my_post) } }
#         it_behaves_like "error flash", "Please log in"
#         it_behaves_like "redirect to path", "/login"
#       end
#     end
#   end
#
#   # マイクロポストの作成（create）
#   describe "create" do
#     # ログイン済みの状態で
#     before { login_as(user) }
#     # normal
#     # valid な情報の場合
#     context "valid info" do
#       # 成功 (increment: 1)
#       scenario "success create (increment: 1)" do
#         expect {
#           visit root_path
#           params = attributes_for(:user_post)
#           fill_in "micropost_content", with: params[:content]
#           click_button "Post"
#           # expect { success_flash("Micropost created") }
#         }.to change(Micropost, :count).by(1)
#       end
#       # successメッセージが出力されること "Micropost created"
#       scenario "success messages" do
#         expect { success_flash("Micropost created") }
#       end
#     end
#     # abnormal
#     # invalid な情報の場合
#     context "invalid info" do
#       scenario "fails create (increment: 0)" do
#         expect {
#           visit root_path
#           fill_in "micropost_content", with: ""
#           click_button "Post"
#           # expect { error_flash }
#         }.to change(Micropost, :count).by(0)
#       end
#       # errrorメッセージが出力されること
#       scenario "error message" do
#         # error_flash
#         expect { error_flash }
#       end
#     end
#   end
#
#   # マイクロポストの削除（delete）
#   describe "destroy" do
#     # ログイン済みの状態で
#     before { login_as(user) }
#     # 成功 (increment: -1)
#     scenario "success delete (increment: -1)" do
#       expect {
#         visit root_path
#         click_link "delete", match: :first
#         # expect { success_flash("Micropost deleted") }
#       }.to change(Micropost, :count).by(-1)
#     end
#     # successメッセージが出力されること
#     # it { expect(page).to have_css("div.alert.alert-success", text: "Micropost deleted") }
#     # it { expect(flash[:success]).to eq "Micropost deleted" }
#     scenario "success message" do
#       # success_flash("Micropost deleted")
#       expect { success_flash("Micropost deleted") }
#     end
#   end
# end







# リスト10.26 マイクロポスト作成のテスト。
# spec/requests/micropost_pages_spec.rb
# require 'spec_helper'
#
# describe "Micropost pages" do
#
#   subject { page }
#
#   let(:user) { FactoryGirl.create(:user) }
#   before { sign_in user }
#
#   describe "micropost creation" do
#     before { visit root_path }
#
#     describe "with invalid information" do
#
#       it "should not create a micropost" do
#         expect { click_button "Post" }.not_to change(Micropost, :count)
#       end
#
#       describe "error message" do
#         before { click_button "Post" }
#         it { should have_content('error') }
#       end
#     end
#
#     describe "with valid information" do
#
#       before { fill_in 'micropost_content', with: "Lorem ipsum" }
#       it "should create a micropost" do
#         expect { click_button "Post" }.to change(Micropost, :count).by(1)
#       end
#     end
#   end
# end
