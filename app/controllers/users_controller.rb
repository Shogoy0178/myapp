# frozen_string_literal: true

# ユーザー登録画面のコントローラ
class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    # ユーザー登録画面に遷移したときにセッションをリセット
    reset_session
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    logger.debug "User params: #{user_params.inspect}" # paramsをログに表示

    if @user.save
      flash[:notice] = 'ユーザー登録が成功しました！'
      redirect_to login_path
    else
      flash[:alert] = 'ユーザー登録に失敗しました。'
      flash[:error_messages] = @user.errors.full_messages # エラーメッセージをflashに格納
      render :new
    end
  end

  def index
    @users = User.order(created_at: :desc) # 登録が新しい順に取得
  end

  # 追加: マイページ表示
  def show
    @user = User.find(params[:id])
    redirect_to root_path, alert: 'アクセス権がありません。' unless @user == current_user
  end

  # 編集画面の表示
  def edit
    @user = User.find(params[:id])
    redirect_to root_path, alert: 'アクセス権がありません。' unless @user == current_user
  end

  # ユーザー情報の更新
  def update
    @user = User.find(params[:id])
    if @user == current_user && @user.update(user_params)
      flash[:notice] = 'ユーザー情報を更新しました。'
      redirect_to @user
    else
      flash[:alert] = 'ユーザー情報の更新に失敗しました。'
      flash[:error_messages] = @user.errors.full_messages
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
