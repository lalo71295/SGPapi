class UsersController < ApplicationController

  def show
    @user = user.find(params[:id])

  end

  def new
  end

  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find(session[:current_user_id])

      
  end

  def destroy
    # Remove the user id from the session
    session[:current_user_id] = nil
    redirect_to root_url
  end

verify :params => [:username, :password],
         :render => {:action => "new", render json:{:user_id};},
         :add_flash => {
           :error => "Username and password required to log in",
           return('0');
         }

  def create
    @user = User.authenticate(params[:username], params[:password])
    if @user
      flash[:notice] = "You're logged in"
      redirect_to root_url
    else
      render :action => "new"
    end
  end

end

