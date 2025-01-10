# frozen_string_literal: true

# セッションコントローラ
class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    user = login(params[:email], params[:password])
    if user
      redirect_to posts_path, notice: 'ログインしました。'
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが正しくありません。'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:notice] = 'ログアウトしました。'
    redirect_to root_path
  end
end
