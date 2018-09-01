class SyncController < AuthenticatedController

  def index
  end

  def synchronize
    alt_character = current_user.alt_characters.find_by_id(params[:alt_character_id])
    if alt_character
      sync_contacts = SynchronizeContacts.perform(user: current_user, alt: alt_character)
      unless sync_contacts.success?
        sync_contacts.errors.messages[:sync].each do |message|
          flash[:alert] = message
        end
      end
    end
    redirect_to sync_path
  end

end
