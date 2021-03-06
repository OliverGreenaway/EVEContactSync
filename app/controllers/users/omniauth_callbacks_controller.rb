class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def crest
    if current_user
      add_alt_character = AddAltCharacter.perform(user: current_user, alt_details: request.env["omniauth.auth"])
      unless add_alt_character.success?
        add_alt_character.errors.messages[:alt_character].each do |message|
          flash[:alert] = "Alt Character #{message}"
        end
      end
      redirect_to dashboard_path
    else
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: "ESI") if is_navigational_format?
      end
    end
  end

  def failure
    redirect_to root_path
  end
end
