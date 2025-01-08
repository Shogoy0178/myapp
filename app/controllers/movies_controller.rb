# frozen_string_literal: true

# 映画情報を取得するためのコントローラ
class MoviesController < ApplicationController
  def index
    movie_api_key = ENV['TMDB_API']
    raise 'TMDB_API key is missing. Please set it in your environment variables.' if movie_api_key.blank?

    if params[:looking_for]
      movie_title = params[:looking_for]
      url = "https://api.themoviedb.org/3/search/movie?api_key=#{movie_api_key}&language=ja&query=" + URI.encode_www_form_component(movie_title)
    else
      url = "https://api.themoviedb.org/3/movie/popular?api_key=#{movie_api_key}&language=ja"
    end

    response = JSON.parse(Net::HTTP.get(URI.parse(url)))
    @movies = response['results']

    # ページネーション設定
    @movies = Kaminari.paginate_array(@movies).page(params[:page]).per(12)
  end

  def save_selected
    selected_movie_id = params[:movie_id]
    post_id = params[:post_id] # 投稿IDを取得

    if selected_movie_id.present?
      movie_api_key = ENV['TMDB_API']
      url = "https://api.themoviedb.org/3/movie/#{selected_movie_id}?api_key=#{movie_api_key}&language=ja&append_to_response=videos"
      movie_response = JSON.parse(Net::HTTP.get(URI.parse(url)))

      first_trailer_key = movie_response.dig('videos', 'results')&.find do |video|
        video['site'] == 'YouTube' && video['type'] == 'Trailer'
      end&.dig('key')
      trailer_url = first_trailer_key ? "https://www.youtube.com/watch?v=#{first_trailer_key}" : nil

      # 映画情報をセッションに保存
      session[:selected_movie] = {
        id: movie_response['id'],
        title: movie_response['title'],
        poster_url: "https://image.tmdb.org/t/p/w500#{movie_response['poster_path']}",
        trailer_url: trailer_url
      }

      if post_id.present?
        post = Post.find(post_id)

        # find_or_create_byを使用して映画を探し、存在しない場合は新規作成
        movie = Movie.find_or_create_by(id: movie_response['id']) do |m|
          m.tmdb_movie_id = movie_response['id']
          m.title = movie_response['title']
          m.poster_url = "https://image.tmdb.org/t/p/w500#{movie_response['poster_path']}"
          m.trailer_url = trailer_url
        end

        # 映画IDを投稿に関連付け
        post.movie_id = movie.id
        post.save
      end

      # 投稿IDが渡されていればedit画面、なければnew画面へ遷移
      if post_id.present?
        redirect_to edit_post_path(post_id)
      else
        redirect_to new_post_path
      end
    else
      redirect_to movies_path, alert: '映画を選択してください。'
    end
  end
end
