require 'rails_helper'

RSpec.describe TopsController, type: :controller do

  # viewの内容を確認できる
  render_views

  # let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  # let(:page_title) { "" }

  describe "GET #home" do
    subject { Proc.new { get :home } }
    it_behaves_like "returns http status", :success
    it_behaves_like "render template", :home
    # render_views してあるので response.body でタイトルを確認できる
    # it { subject.call; expect(response.body).to include base_title }
    it_behaves_like "pages should have title", "Home"
  end

  describe "GET #help" do
    subject { Proc.new { get :help } }
    it_behaves_like "returns http status", :success
    it_behaves_like "render template", :help
    it_behaves_like "pages should have title", "Help"
  end

  describe "GET #about" do
    subject { Proc.new { get :about } }
    it_behaves_like "returns http status", :success
    it_behaves_like "render template", :about
    it_behaves_like "pages should have title", "About"
  end

  describe "GET #contact" do
    subject { Proc.new { get :contact } }
    it_behaves_like "returns http status", :success
    it_behaves_like "render template", :contact
    it_behaves_like "pages should have title", "Contact"
  end
end


# Tips
# controllerのテストついでに、viewの内容を確認したい場合
# render_viewsと書いた後にresponse.bodyの内容を確認する
#   describe 'GET #new'
#     render_views
#   # ...
#   end
#


# require 'rails_helper'
#
# RSpec.describe TopsController, type: :controller do
#
#   describe "GET #home" do
#     it "returns http success" do
#       get :home
#       expect(response).to have_http_status(:success)
#     end
#   end
#
#   describe "GET #help" do
#     it "returns http success" do
#       get :help
#       expect(response).to have_http_status(:success)
#     end
#   end
#
#   describe "GET #about" do
#     it "returns http success" do
#       get :about
#       expect(response).to have_http_status(:success)
#     end
#   end
#
#   describe "GET #contact" do
#     it "returns http success" do
#       get :contact
#       expect(response).to have_http_status(:success)
#     end
#   end
# end
#
#
