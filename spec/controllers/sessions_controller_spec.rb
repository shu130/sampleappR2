require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    subject { Proc.new { get :new } }
    it_behaves_like "returns http status", :success
    # it_behaves_like "assigned @value is equal value", :user
    it_behaves_like "render template", :new
  end

  describe "POST #create" do
    let(:user) { create(:user) }
    # allow(オブジェクト).to receive(メソッド名).and_return(戻り値)
    before(:each) { allow(User).to receive(:find_by).and_return(user) }
    # normal
    context "with valid infomation" do
      subject do
        Proc.new { post :create, params: { session: { email: user.email, password: user.password } } }
      end
      it_behaves_like "assigned @value is equal value", :user
      it_behaves_like "returns http status", :redirect
      it_behaves_like "redirect to url", "/users/1"
    end
    # abnormal
    context "with invalid infomation" do
      subject do
        Proc.new { post :create, params: { session: { email: user.email, password: "invalid" } } }
      end
      it_behaves_like "error message", "Invalid email/password combination"
      it_behaves_like "render template", :new
    end
  end

  # # わからない？？？
  # describe "DELETE #destroy"
end






# # Tips
# # stub, mock
# #  /sessions_controller_spec.rb
# describe 'sessions#create' do
#     context '正常なログイン情報でログインした場合' do
#       before do
#         user = create(:user)
#         allow(User).to receive(:find_by).and_return(user)
#       end
#       it 'TOP画面へ遷移されること' do
#         post :create, params: { session: { login_id: 'id', password: 'pass' } }
#         expect(response).to redirect_to top_path
#       end
#    end
# end
#
# #  /sessions_controller.rb
# class SessionsController < ApplicationController
#
#   skip_before_action :user_logged_in?
#
# def create
#       user = User.find_by(login_id: params[:session][:login_id])
#       if user == user.authenticate(params[:session][:password])
#           log_in user
#           redirect_to top_path
#       else
#           redirect_to login_path, flash: { alert: '※ログイン情報が正しくありません'}
#     end
#   end
#
# #  /user.rb
# FactoryGirl.define do
#     factory :user do
#         login_id 'test'
#         password 'password'
#         last_name '田中'
#         first_name '正'
#         group_id 1
#         role_id 1
#     end
# emd
