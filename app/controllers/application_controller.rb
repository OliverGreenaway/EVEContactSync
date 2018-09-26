class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }
end
