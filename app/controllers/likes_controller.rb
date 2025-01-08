# frozen_string_literal: true

# いいね機能のコントローラ
class LikesController < ApplicationController
  before_action :set_post

  def create
    @like = @post.likes.find_or_create_by(user: current_user)

    respond_to do |format|
      format.turbo_stream { render_turbo_stream }
      format.html { redirect_to @post, notice: 'いいねしました' }
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)

    if @like&.destroy
      respond_to do |format|
        format.turbo_stream { render_turbo_stream }
        format.html { redirect_to @post, notice: 'いいねを取り消しました' }
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: 'エラーが発生しました' }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def render_turbo_stream
    render turbo_stream: turbo_stream.replace("like-button-#{@post.id}", partial: 'posts/like_button', locals: { post: @post })
  end
end
