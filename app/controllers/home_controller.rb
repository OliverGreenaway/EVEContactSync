class HomeController < ApplicationController

  def index
    redirect_to sync_path if current_user
  end

end
