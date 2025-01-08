# frozen_string_literal: true

# ApplicationControllerは全てのコントローラーの親クラスとなるクラス
class ApplicationController < ActionController::Base
  before_action :require_login

  private

  # ログインしていない場合、ログインページにリダイレクトするメソッド
  def require_login
    return if logged_in?

    redirect_to login_path
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
