class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  # 一覧表示
  def index
  end  

  def show
  end

  # 新規作成フォーム
  def new
    # @post = Post.new
  end

  # 投稿の保存
  def create
    # @post = Post.new(post_params)
    # if @post.save
    #   redirect_to posts_path, notice: "投稿が作成されました。"
    # else
    #   render :new
    # end
  end

  # 編集フォーム
  def edit
  end

  # 投稿の更新
  def update
    # if @post.update(post_params)
    #   redirect_to posts_path, notice: "投稿が更新されました。"
    # else
    #   render :edit
    # end
  end

  # 投稿の削除
  def destroy
    # @post.destroy
    # redirect_to posts_path, notice: "投稿が削除されました。"
  end

  private

  def set_post
    # @post = Post.find(params[:id])
  end

  def post_params
    # params.require(:post).permit(:title, :body)
  end
end
