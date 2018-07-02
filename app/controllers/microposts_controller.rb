class MicropostsController < ApplicationController

  # from ApplicationController
  before_action :logged_in_check, only: [:create, :destroy]
  before_action :right_user_check, only: [:destroy]

  def create
    # logged_in_check
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created"
      redirect_to root_url
    else
      @feed_items = []
      render 'tops/home'
    end
  end

  def destroy
    # right_user_check
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params[:micropost].permit(:content, :picture)
    end

    # before_action
    def right_user_check
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
