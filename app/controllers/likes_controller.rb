class LikesController < ApplicationController
  before_action :set_post

  def create
    @like = @post.likes.create(user: current_user)

    respond_to do |format|
      format.turbo_stream  # Turbo Streamで部分的な更新を処理
      format.html { redirect_to posts_path }
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    @like.destroy if @like

    respond_to do |format|
      format.turbo_stream  # Turbo Streamで部分的な更新を処理
      format.html { redirect_to posts_path }
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id])
    if @post.nil?
      flash[:alert] = '投稿が見つかりません'
      redirect_to posts_path
    end
  end
end
