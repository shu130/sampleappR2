                      # shared_examples
  # assigns
  shared_examples_for "assigned @value is equal value" do |value|
    it { subject.call; expect(value).to eq value }
  end
  # http status
  shared_examples_for "returns http status" do |status|
    it { subject.call; expect(response).to have_http_status(status) }
  end
  # render template
  shared_examples_for "render template" do |template|
    it { subject.call; expect(response).to render_template template }
  end
  # redirect to path
  shared_examples_for "redirect to path" do |path|
    it { subject.call; expect(response).to redirect_to path }
  end

  # # redirect to path
  # shared_examples_for "redirect to user_path" do |user|
  #   it { subject.call; expect(response).to redirect_to user_path(user) }
  # end

  # flash
  # flash[:success]
  shared_examples_for "have success messages" do |msg|
    it { subject.call; expect(flash[:success]).to eq msg }
  end
  # flash[:danger]
  shared_examples_for "have error messages" do |msg|
    it { subject.call; expect(flash[:danger]).to eq msg }
  end

  # # ↓ なぜかNG
  # # error
  # shared_examples_for "have error 'can't be blank'" do |attribute|
  #   it { subject.call; expect(other_user.errors[attribute]).to include "can't be blank" }
  # end

  # おまけ
  # ページタイトル
  shared_examples_for "pages should have title" do |page_title|
    let(:base_title) { "Ruby on Rails Tutorial Sample App" }
    if page_title == "Home"
      it { subject.call; expect(response.body).to include "#{base_title}" }
      # it { subject.call; expect(response.body).to include "base_title" }
    else
      it { subject.call; expect(response.body).to include "#{page_title} | #{base_title}" }
      # it { subject.call; expect(response.body).to include "page_title | base_title" }
    end
  end

  # model
  # create/update/delete
  # create
  shared_examples_for "create data (increment:1)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(1) } # or
    # it { expect{ subject.call }.to change{ model.count }.by(1) }
  end
  # update
  shared_examples_for "update data (increment:0)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(0) }
  end
  # delete
  shared_examples_for "delete data (increment:-1)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(-1) }
  end
  # not change case
  shared_examples_for "not change data (increment:0)" do |model|
    it { expect{ subject.call }.to change(model, :count).by(0) }
  end



                      # モデルスペック

# Userモデル

  shared_examples_for "User-model respond to attribute or method" do
    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:authenticate) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:remember_digest) }
    it { should respond_to(:activation_digest) }
    it { should respond_to(:admin) }
    it { should respond_to(:microposts) }
    it { should respond_to(:feed) }
    it { should respond_to(:relationships) }
  end

  # ボツ
  # shared_examples_for "non-presence" do |attr|
  #   before { user.attr = "   " }
  #   # attr = "   "
  #   it { expect{ subject.call }; not_to be_valid }
  # end

# Micropostモデル

  shared_examples_for "Micropost-model respond to attribute or method" do
    it { should respond_to(:content) }
    it { should respond_to(:user_id) }
  end

# Relationshipモデル

  # shared_examples_for "Relationship-model respond to method" do
  shared_examples_for "follower-methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    # its(:follower) { should eq follower }
    # its(:followed) { should eq followed }
  end
