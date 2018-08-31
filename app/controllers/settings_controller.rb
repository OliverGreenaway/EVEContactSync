class SettingsController < AuthenticatedController

  def edit
  end

  def update
    current_user.settings.update(settings_params)
    redirect_to sync_path
  end

  private

  def settings_params
    params.require(:settings).permit(:sync_char_contacts, :sync_corp_contacts, :sync_ally_contacts)
  end

end
