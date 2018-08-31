class UsersController < ApplicationController

  before_action :logged_in_check,
    only: [:index, :edit, :update, :destroy, :following, :followers ]

  before_action :right_user_check, only: [:edit, :update]
  before_action :admin_user_ckeck, only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
    # @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      # UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # before_action
    #  :logged_in_check, :right_user_check
  end

  def update
    # before_action
    #  :logged_in_check, :right_user_check
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).delete
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    # create, destroy
    def user_params
      params[:user].permit(:name, :email,
                            :password, :password_confirmation)
    end

    # before_action

    def right_user_check
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end

    def admin_user_ckeck
      redirect_to(root_url) unless current_user.admin?
    end

    # # 移設 (application_controller.rb)
    # def logged_in_check
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Please log in"
    #     redirect_to login_url
    #   end
    # end
end


# class UsersController < ApplicationController
#
#   before_action :logged_in_check,
#     only: [:index, :edit, :update, :destroy, :following, :followers ]
#
#   before_action :right_user_check, only: [:edit, :update]
#   before_action :admin_user_ckeck, only: [:destroy]
#
#   def index
#     @users = User.paginate(page: params[:page])
#   end
#
#   def show
#     @user = User.find(params[:id])
#     @microposts = @user.microposts.paginate(page: params[:page])
#   end
#
#   def new
#     @user = User.new
#   end
#
#   def create
#     @user = User.new(user_params)
#     if @user.save
#       # UserMailer.account_activation(@user).deliver_now
#       # flash[:info] = "Please check your email to activate your account."
#       # redirect_to root_url
#       log_in @user
#       flash[:success] = "Welcome to the Sample App!"
#       redirect_to @user
#     else
#       render 'new'
#     end
#   end
#
#   def edit
#     # before_action
#     #  :logged_in_check, :right_user_check
#   end
#
#   def update
#     # before_action
#     #  :logged_in_check, :right_user_check
#     if @user.update_attributes(user_params)
#       flash[:success] = "Profile updated"
#       redirect_to @user
#     else
#       render 'edit'
#     end
#   end
#
#   def destroy
#     User.find(params[:id]).delete
#     flash[:success] = "User deleted"
#     redirect_to users_url
#   end
#
#   def following
#     @title = "Following"
#     @user = User.find(params[:id])
#     @users = @user.following.paginate(page: params[:page])
#     render 'show_follow'
#   end
#
#   def followers
#     @title = "Followers"
#     @user = User.find(params[:id])
#     @users = @user.followers.paginate(page: params[:page])
#     render 'show_follow'
#   end
#
#   private
#
#     # create, destroy
#     def user_params
#       params[:user].permit(:name, :email,
#                             :password, :password_confirmation)
#     end
#
#     # before_action
#
#     def right_user_check
#       @user = User.find(params[:id])
#       redirect_to(root_url) unless @user == current_user
#     end
#
#     def admin_user_ckeck
#       redirect_to(root_url) unless current_user.admin?
#     end
#
#     # # 移設 (application_controller.rb)
#     # def logged_in_check
#     #   unless logged_in?
#     #     store_location
#     #     flash[:danger] = "Please log in"
#     #     redirect_to login_url
#     #   end
#     # end
# end
