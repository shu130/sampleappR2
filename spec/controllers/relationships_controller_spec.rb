# require 'rails_helper'
#
# RSpec.describe RelationshipsController, type: :controller do
#
#   include_context "setup"
#
#   # フォロー対象のユーザ
#   before { allow(Relationship).to receive(:find_by).and_return(other_user) }
#   # before { allow(User).to receive(:find_by).and_return(user) }
#
#   describe "create with Ajax" do
#     before { log_in_as user }
#     # subject { Proc.new { xhr :post, :create, params: { followed_id: other_user.id } } }
#     # it_behaves_like "create data (increment:1)", Relationship
#
#     # it "should create a relationship (increment:1)" do
#     #   expect {
#     #     post :create, params: { relationship: { followed_id: other_user.id } }
#     #   }.to change(Relationship, :count).by(1)
#     # end
#
#     # # テキスト
#     # it "should increment the Relationship count" do
#     #   expect do
#     #     xhr :post, :create, relationship: { followed_id: other_user.id }
#     #   end.to change(Relationship, :count).by(1)
#     # end
#
#     # it "should create a relationship (increment:1)" do
#     #   expect {
#     #     xhr :post, :create, params: { relationships: { followed_id: other_user.id } }
#     #   }.to change(Relationship, :count).by(1)
#     # end
#   end
#
# end
