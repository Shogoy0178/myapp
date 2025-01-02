class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def require_login
    unless logged_in?
      redirect_to login_path
    end
  end  

  # ログイン中のユーザーを返すメソッド
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  # ログイン状態を確認するメソッド
  def logged_in?
    current_user.present?
  end
end
