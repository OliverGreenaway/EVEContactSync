class DashboardController < AuthenticatedController
  before_action :check_manual, only: [:index]

  def index
    # Fetch information on a character the first time the dashboard is visited
    EveSwaggerInterfaceService.new(current_user).char_information unless current_user.corp_id
  end

  def synchronize
    alt_character = current_user.alt_characters.find_by_id(params[:alt_character_id])
    if alt_character
      sync_contacts = SynchronizeContacts.perform(user: current_user, alt: alt_character, source: :manual)
      if sync_contacts.success?
        flash[:notice] = "Sync of contacts to #{alt_character.name} successful"
      else
        sync_contacts.errors.messages[:sync].each do |message|
          flash[:alert] = message
        end
      end
    end
    redirect_to dashboard_path
  end

  def remove_alt
    alt_character = current_user.alt_characters.find(params[:alt_character_id])
    alt_character.delete
    redirect_to dashboard_path
  end

  def check_manual
    unless current_user.viewed_manual
      flash[:notice] = "Welcome to Alt Contact Sync, to view instructions on how to use, check out our <a href='#{manual_path}'>Manual</a>".html_safe
      flash[:html_safe] = true
    end
  end

end
