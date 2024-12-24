class MoviesController < ApplicationController
  
  # 一覧表示
  def index
    movie_api_key = ENV['TMDB_API']
    if movie_api_key.blank?
      raise "TMDB_API key is missing. Please set it in your environment variables."
    end
    
    if params[:looking_for]
      movie_title = params[:looking_for]
      url = "https://api.themoviedb.org/3/search/movie?api_key=#{movie_api_key}&language=ja&query=" + URI.encode_www_form_component(movie_title)
    else
      url = "https://api.themoviedb.org/3/movie/popular?api_key=#{movie_api_key}&language=ja"
    end
  
    response = JSON.parse(Net::HTTP.get(URI.parse(url)))
    @movies = response["results"].first(30)  # 最初の5件だけ取得
  
    # デバッグ情報をログに出力
    logger.debug "Movies with Trailers: #{@movies}"
  end  

  def show
    movie_id = params[:id]
    url = "https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{ENV['TMDB_API']}&language=ja"
    movie_response = JSON.parse(Net::HTTP.get(URI.parse(url)))
  
    # 予告編情報を追加
    video_url = "https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{ENV['TMDB_API']}&append_to_response=videos&language=ja"
    video_response = JSON.parse(Net::HTTP.get(URI.parse(video_url)))
    
    # 予告編（YouTube）のみを抽出
    trailers = video_response.dig("videos", "results")&.select { |video| video["site"] == "YouTube" && video["type"] == "Trailer" }
  
    # 映画情報に予告編を追加
    @movie = movie_response
    @trailers = trailers
  end  
end
