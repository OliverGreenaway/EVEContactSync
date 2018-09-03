class HomeController < ApplicationController

  def index
    redirect_to dashboard_path if current_user
  end

  def manual
    if current_user
      current_user.update(viewed_manual: true)
    end
  end

end
