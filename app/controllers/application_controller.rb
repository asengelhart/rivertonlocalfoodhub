class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?
  
  def logged_in?
    session.include? :user_id
  end

  def needs_login
    unless logged_in?
      redirect_to login_path
    end
  end
  
  def current_user
    session[:user_id] if logged_in? && User.find_by(id: session[:user_id])
  end
end
