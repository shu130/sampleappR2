RSpec.shared_context "setup" do

                          # user

  # 遅延評価、呼ばれた時にDB保存される
  let(:user) { create(:user) }
  let(:users) { create_list(:other_user, 30) }
  let(:other_user) { create(:other_user) }
  let(:admin) { create(:admin) }

  # 属性をハッシュ化して呼ばれた時に使う
  let(:valid_params) { attributes_for(:user) }
  let(:invalid_params) { attributes_for(:user, name: nil) }
  let(:update_params_1) { attributes_for(:user, name: "New name") }
  let(:update_params_2) { attributes_for(:other_user, name: "New name") }
  let(:admin_params) { attributes_for(:user, admin: true) }

                          # micropost

  # 遅延評価、呼ばれた時にDB保存される
  # 自分の投稿
  let(:my_post) { create(:user_post) }
  let(:my_posts) { create_list(:user_post, 30, user: user) }
  # let(:my_posts) { create_list(:user_post, 30) }
  # 他人の投稿
  let(:other_post) { create(:other_user_post) }
  let(:other_posts) { create_list(:other_user_post, 30, user: other_user) }
  # let(:other_posts) { create_list(:other_user_post, 30) }

  # 属性をハッシュ化して呼ばれた時に使う
  let(:post_params) { attributes_for(:user_post) }
  let(:valid_post_params) { attributes_for(:user_post) }
  let(:invalid_post_params) { attributes_for(:user_post, content: nil) }

end







# RSpec.shared_context "setup" do
#
#   # user
#
#   # let で 変数が呼ばれたタイミングで DB保存されるようにしておく
#   let(:user) { create(:user) }
#   let(:users) { create_list(:other_user, 30) }
#   let(:other_user) { create(:other_user) }
#   let(:admin) { create(:admin) }
#
#   # # let! で DBに保存
#   # let!(:user) { create(:user) }
#   # let!(:admin) { create(:admin) }
#
#   # let! で DBに保存
#   # let!(:users) { create_list(:other_user, 30) } # User.paginate で使用
#   # let!(:other_user) { create(:other_user) }
#
#   # 属性をハッシュ化して呼ばれた時に使う
#   let(:valid_params) { attributes_for(:user) }
#   let(:invalid_params) { attributes_for(:user, name: nil) }
#   let(:update_params_1) { attributes_for(:user, name: "New name") }
#   let(:update_params_2) { attributes_for(:other_user, name: "New name") }
#   let(:admin_params) { attributes_for(:user, admin: true) }
#
#   # micropost
#
#   # # マイクロポストを作成し、let! で DB保存
#   # # 自分の投稿
#   # let!(:my_post) { create(:user_post) }
#   # let!(:my_posts) { create_list(:user_post, 30) }
#   # # 他人の投稿
#   # let!(:other_post) { create(:other_user_post) }
#
#   # マイクロポストを作成し、呼ばれた時に使う
#   # 自分の投稿
#   let(:my_post) { create(:user_post) }
#   let(:my_posts) { create_list(:user_post, 30) }
#   # 他人の投稿
#   let(:other_post) { create(:other_user_post) }
#   let(:other_posts) { create_list(:other_user_post, 30) }
#
#   # 属性をハッシュ化して、呼ばれた時に使う
#   let(:post_params) { attributes_for(:user_post) }
#   let(:valid_post_params) { attributes_for(:user_post) }
#   let(:invalid_post_params) { attributes_for(:user_post, content: nil) }
#
# end




#                       # shared_context
#
# RSpec.shared_context "setup" do
#
#   # user
#
#   # let で 変数が呼ばれたタイミングで DB保存されるようにしておく
#   let(:user) { create(:user) }
#   let(:users) { create_list(:other_user, 30) }
#   let(:other_user) { create(:other_user) }
#   let(:admin) { create(:admin) }
#
#   # # let! で DBに保存
#   # let!(:user) { create(:user) }
#   # let!(:admin) { create(:admin) }
#
#   # # let! で DBに保存
#   # let!(:users) { create_list(:other_user, 30) }
#   # let!(:other_user) { create(:other_user) }
#
#   # 属性をハッシュ化して呼ばれた時に使う
#   let(:valid_params) { attributes_for(:user) }
#   let(:invalid_params) { attributes_for(:user, name: nil) }
#   let(:update_params_1) { attributes_for(:user, name: "New name") }
#   let(:update_params_2) { attributes_for(:other_user, name: "New name") }
#   let(:admin_params) { attributes_for(:user, admin: true) }
#
#   # micropost
#
#   # # マイクロポストを作成し、let! で DB保存
#   # # 自分の投稿
#   # let!(:my_post) { create(:user_post) }
#   # let!(:my_posts) { create_list(:user_post, 30) }
#   # # 他人の投稿
#   # let!(:other_post) { create(:other_user_post) }
#
#   # マイクロポストを作成し、呼ばれた時に使う
#   # 自分の投稿
#   let(:my_post) { create(:user_post) }
#   let(:my_posts) { create_list(:user_post, 30) }
#   # 他人の投稿
#   let(:other_post) { create(:other_user_post) }
#
#   # 属性をハッシュ化して呼ばれた時に使う
#   let(:post_params) { attributes_for(:user_post) }
#   let(:valid_params) { attributes_for(:user_post) }
#   let(:invalid_params) { attributes_for(:user_post, content: nil) }
#
# end
