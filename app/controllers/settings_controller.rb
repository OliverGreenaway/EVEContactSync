class SettingsController < AuthenticatedController

  def edit
  end

  def update
    current_user.settings.update(settings_params)
    redirect_to dashboard_path
  end

  def premium_settings
    current_user.alt_characters.each do |alt|
      label = params["label_#{alt.id}"].to_i
      if label == AltCharacter::DEFAULT_LABEL["label_id"]
        alt.update(label_id: label, label_name: AltCharacter::DEFAULT_LABEL["label_name"])
      elsif label != alt.label_id
        label_hash = alt.labels.detect {|l| l["label_id"] == label }
        alt.update(label_id: label, label_name: label_hash["label_name"])
      end
    end
    redirect_to dashboard_path
  end

  private

  def settings_params
    params.require(:settings).permit(:sync_char_contacts, :sync_corp_contacts, :sync_ally_contacts)
  end

end
