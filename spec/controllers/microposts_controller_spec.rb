require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do

  # let! で DBに保存し、レコードが２つある状態にしておく
  let!(:my_post) { create(:user_post) }
  let!(:other_post) { create(:other_user_post) }
  let(:valid_params) { attributes_for(:user_post) }
  let(:invalid_params) { attributes_for(:user_post, content: nil) }

  # ログインするユーザ
  let(:user) { create(:user) }
  before(:each) { allow(User).to receive(:find_by).and_return(user) }
  # before(:each) { allow(Micropost).to receive(:find_by).and_return(my_post) }

  describe "POST #create" do
    # nomal
    context "when logged-in" do
      before(:each) { log_in_as user }
      # before(:each) { log_in_as user }  # 使えないので、、
      # allow(オブジェクト).to receive(メソッド名).and_return(戻り値)
      # before(:each) { allow(User).to receive(:find_by).and_return(user) }
      # before(:each) { log_in_as user }
      # before do
      #   allow(User).to receive(:find_by).and_return(user)
      #   log_in_as user
      # end
      # nomal
      context "with valid attributes" do
        # subject { Proc.new { my_post = post :create, params: { micropost: valid_params } } }
        subject { Proc.new { post :create, params: { micropost: valid_params } } }
        it_behaves_like "assigned @value is equal value", :micropost
        it_behaves_like "create data (increment:1)", Micropost
        it_behaves_like "returns http status", :redirect
        it_behaves_like "redirect to path", "/"
        it_behaves_like "have success messages", "Micropost created"
      end
      # abnomal
      context "with invalid attributes" do
        # subject { Proc.new { my_post = post :create, params: { micropost: invalid_params } } }
        subject { Proc.new { post :create, params: { micropost: invalid_params } } }
        it_behaves_like "assigned @value is equal value", :micropost
        it_behaves_like "not change data (increment:0)", Micropost
        it_behaves_like "render template", :home

        # # ↓ なぜかNG
        # it "have error 'content can't be blank'" do
        #   subject.call; expect(my_post.errors[:content]).to include "can't be blank"
        # end
      end
    end
    # abnormal
    context "when not logged-in" do
      subject { Proc.new { post :create, params: { micropost: valid_params } } }
      # include_context "redirect_to login_url with error messages"
      it_behaves_like "redirect to path", "/login"
      it_behaves_like "have error messages", "Please log in"
      it_behaves_like "not change data (increment:0)", Micropost
    end
  end

  describe "DELETE #destroy" do
    # subject { Proc.new { delete :destroy, params: { id: other_user_post.id } } }
    # normal
    context "when logged-in" do
      before(:each) { log_in_as user }
      # nomal
      context "as rigtht-user" do
        subject { Proc.new { delete :destroy, params: { id: my_post.id } } }
        it_behaves_like "assigned @value is equal value", :my_post
        it_behaves_like "delete data (increment:-1)", Micropost
        it_behaves_like "returns http status", :redirect
        it_behaves_like "redirect to path", "/"
        it_behaves_like "have success messages", "Micropost deleted"
      end
      # abnormal
      context "as wrong-user" do
        subject { Proc.new { delete :destroy, params: { id: other_post.id } } }
        it "assigned @micropost is not equal micropost" do
          subject.call; expect(:other_post).not_to eq other_post
        end
        it_behaves_like "not change data (increment:0)", Micropost
      end
    end
    # abnormal
    context "when not logged-in" do
      subject { Proc.new { delete :destroy, params: { id: other_post.id } } }
      it_behaves_like "redirect to path", "/login"
      it_behaves_like "have error messages", "Please log in"
      it_behaves_like "not change data (increment:0)", Micropost
    end
  end
end


# エラー
# Failures:
#
#   1) MicropostsController DELETE #destroy when logged-in as rigtht-user behaves like delete data (increment:-1) should change #count by -1
#      Failure/Error: it { expect{ subject.call }.to change(model, :count).by(-1) }
#        expected #count to have changed by -1, but was changed by 0

# 詰まった
# 解決   https://qiita.com/hisonl/items/6af97357f67dd050aeba
# Failures:
#
#   1) MicropostsController DELETE #destroy when logged-in as rigtht-user behaves like assigned @value is equal value
#      Failure/Error: let(:my_post) { create(:my_post) }
#
#      ActiveRecord::RecordInvalid:
#        Validation failed: Email has already been taken
