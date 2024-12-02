class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "ユーザー登録が完了しました。"
    else
      flash.now[:alert] = "登録に失敗しました。"
      render :new
    end
  end

  private

  def user_params
    # 必要なカラムを指定
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

