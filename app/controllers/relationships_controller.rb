class RelationshipsController < ApplicationController

  before_action :logged_in_check

  # Ajax
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js  # => create.js.erb
    end
  end

  def destroy
    # DELETE /relationships/id
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js  # => destroy.js.erb
    end
  end

  # # not Ajax
  # def create
  #   user = User.find(params[:followed_id])
  #   current_user.follow(user)
  #   redirect_to user
  # end
  #
  # def destroy
  #   # DELETE /relationships/id
  #   user = Relationship.find(params[:id]).followed
  #   current_user.unfollow(user)
  #   redirect_to user
  # end


end
