class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    logger.debug "User params: #{user_params.inspect}" # paramsをログに表示    

    if @user.save
      flash[:notice] = "ユーザー登録が成功しました！"
      redirect_to login_path
    else
      flash[:alert] = "ユーザー登録に失敗しました。"
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
    redirect_to root_path, alert: "アクセス権がありません。" unless @user == current_user
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
