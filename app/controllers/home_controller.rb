class HomeController < ApplicationController
  def top
    redirect_to login_path unless current_user
  end  
end
