class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  include SessionsHelper

  private
    # for UsersController, MicropostsController
    def logged_in_check
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_path
      end
    end

end
