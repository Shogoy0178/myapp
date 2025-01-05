class LikesController < ApplicationController
  before_action :set_post

  def create
    @like = @post.likes.new(user: current_user)

    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: 'いいねしました' }
      end
    else
      # エラーハンドリング
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    if @like&.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: 'いいねを取り消しました' }
      end
    else
      # エラーハンドリング
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
