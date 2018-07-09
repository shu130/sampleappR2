require 'rails_helper'

RSpec.feature "MicropostPages", type: :feature do

  include SupportModule
  # include_context "setup"

  subject { page }

  let(:user) { create(:user) }

  # マイクロポストを作成し、let! で DB保存
  let!(:my_post) { create(:user_post) }
  let!(:my_posts) { create_list(:user_post, 4) }

  # 未ログインのテスト （before_action のテスト）
  describe "login is necessary", type: :request do
    context "non-login" do
      describe "create" do
        subject { Proc.new { post microposts_path } }
        it_behaves_like "error message", "Please log in"
        it_behaves_like "redirect to path", "/login"
      end
      describe "destroy" do
        subject { Proc.new { delete micropost_path(my_post) } }
        it_behaves_like "error message", "Please log in"
        it_behaves_like "redirect to path", "/login"
      end
    end
  end

  # マイクロポストの作成（create）
  describe "create" do
    # ログイン済みの状態で
    before { login_as(user) }
    # normal
    # valid な情報の場合
    context "valid info" do
      # 成功 (increment: 1)
      scenario "success create (increment: 1)" do
        expect {
          visit root_path
          params = attributes_for(:user_post)
          fill_in "micropost_content", with: params[:content]
          click_button "Post"
          # expect { success_flash("Micropost created") }
        }.to change(Micropost, :count).by(1)
      end
      # successメッセージが出力されること "Micropost created"
      scenario "success messages" do
        expect { success_flash("Micropost created") }
      end
    end
    # abnormal
    # invalid な情報の場合
    context "invalid info" do
      scenario "fails create (increment: 0)" do
        expect {
          visit root_path
          fill_in "micropost_content", with: ""
          click_button "Post"
          # expect { error_flash }
        }.to change(Micropost, :count).by(0)
      end
      # errrorメッセージが出力されること
      scenario "error message" do
        # error_flash
        expect { error_flash }
      end
    end
  end

  # マイクロポストの削除（delete）
  describe "destroy" do
    # ログイン済みの状態で
    before { login_as(user) }
    # 成功 (increment: -1)
    scenario "success delete (increment: -1)" do
      expect {
        visit root_path
        click_link "delete", match: :first
        # expect { success_flash("Micropost deleted") }
      }.to change(Micropost, :count).by(-1)
    end
    # successメッセージが出力されること
    # it { expect(page).to have_css("div.alert.alert-success", text: "Micropost deleted") }
    # it { expect(flash[:success]).to eq "Micropost deleted" }
    scenario "success message" do
      # success_flash("Micropost deleted")
      expect { success_flash("Micropost deleted") }
    end
  end
end



# # アウトライン
#
#   ログイン済みの状態
#   # マイクロポストの投稿（create）
#   describe "create"
#     # valid な情報の場合
#     context "valid info"
#       increment: 1 であること
#       successメッセージが出力されること "Micropost created"
#     # invalid な情報の場合
#     context "invalid info"
#       increment: 0 であること
#       errrorメッセージが出力されること
#
#   # マイクロポストの削除（destroy）
#   describe "destroy"
#       increment: -1 であること
#       フラッシュメッセージが出力されること "Micropost deleted"





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
