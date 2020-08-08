class SessionsController < ApplicationController
  def create
    @user = User.find_by(name: params[:name])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
    else
      flash.now[:alert] = "Incorrect username or password."
      render :new
    end
  end

  def new
    render :new
  end

  def login_params
    params.require(:user).permit(:name, :password)
  end
end
