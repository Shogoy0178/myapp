class MoviesController < ApplicationController
  def index
    movie_api_key = ENV['TMDB_API']
    raise "TMDB_API key is missing. Please set it in your environment variables." if movie_api_key.blank?

    if params[:looking_for]
      movie_title = params[:looking_for]
      url = "https://api.themoviedb.org/3/search/movie?api_key=#{movie_api_key}&language=ja&query=" + URI.encode_www_form_component(movie_title)
    else
      url = "https://api.themoviedb.org/3/movie/popular?api_key=#{movie_api_key}&language=ja"
    end

    response = JSON.parse(Net::HTTP.get(URI.parse(url)))
    @movies = response["results"].first(30)
  end

  # 映画を選択して保存
  def save_selected
    selected_movie_id = params[:movie_id]
  
    if selected_movie_id.present?
      movie_api_key = ENV['TMDB_API']
      # 映画の基本情報を取得
      url = "https://api.themoviedb.org/3/movie/#{selected_movie_id}?api_key=#{movie_api_key}&language=ja&append_to_response=videos"
      movie_response = JSON.parse(Net::HTTP.get(URI.parse(url)))
  
      # 最初の予告編を抽出
      first_trailer_key = movie_response.dig("videos", "results")&.find { |video| video["site"] == "YouTube" && video["type"] == "Trailer" }&.dig("key")
      trailer_url = first_trailer_key ? "https://www.youtube.com/watch?v=#{first_trailer_key}" : nil
  
      # セッションに映画情報を保存
      session[:selected_movie] = {
        id: movie_response["id"],
        title: movie_response["title"],
        poster_url: "https://image.tmdb.org/t/p/w500#{movie_response['poster_path']}",
        trailer_url: trailer_url
      }
  
      logger.debug "Selected Movie: #{session[:selected_movie].inspect}"
  
      redirect_to new_post_path  # 映画情報を新規投稿フォームに戻す
    else
      redirect_to movies_path, alert: "映画を選択してください。"
    end
  end  
end
