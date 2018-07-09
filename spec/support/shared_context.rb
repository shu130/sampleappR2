                      # shared_context

RSpec.shared_context "setup" do

                      # user

  # let! で DBに保存し、レコードが７つある状態にしておく
  # let!(:other_users) { create_list(:other_user, 5) }
  let!(:other_users) { create_list(:other_user, 30) }
  let!(:other_user) { create(:other_user) }
  let!(:admin) { create(:admin) }
  # let で 変数が呼ばれたタイミングで DB保存されるようにしておく
  let(:user) { create(:user) }

  # 属性をハッシュ化して呼ばれた時に使う
  let(:valid_params) { attributes_for(:user) }
  let(:invalid_params) { attributes_for(:user, name: nil) }
  let(:update_params_1) { attributes_for(:user, name: "New name") }
  let(:update_params_2) { attributes_for(:other_user, name: "New name") }
  let(:admin_params) { attributes_for(:user, admin: true) }

                      # micropost

  # マイクロポストを４つ作成し、let! で DB保存
  let!(:my_posts) { create_list(:user_post, 30) }  

end
