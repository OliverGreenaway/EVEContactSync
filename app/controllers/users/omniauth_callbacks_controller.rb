class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def crest
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "ESI") if is_navigational_format?
    end
  end

  def failure
    redirect_to root_path
  end
end
