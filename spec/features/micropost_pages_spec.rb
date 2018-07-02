require 'rails_helper'

RSpec.feature "MicropostPages", type: :feature do
  include SupportModule

  let(:user) { create(:user) }
  let!(:my_post) { create(:user_post) }
  before { login_as(user) }

  describe "create" do
    # normal
    context "valid info" do
      scenario "success create micropost" do
        expect {
          visit root_path
          params = attributes_for(:user_post)
          fill_in "micropost_content", with: params[:content]
          click_button "Post"
        }.to change(Micropost, :count).by(1)
      end
    end
    # abnormal
    context "invalid info" do
      scenario "success create micropost" do
        expect {
          visit root_path
          fill_in "micropost_content", with: ""
          click_button "Post"
        }.to change(Micropost, :count).by(0)
      end
    end
  end

  describe "destroy" do
    scenario "success delete micropost" do
      expect {
        visit root_path

      }
    end
  end

end



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
#       describe "error messages" do
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
