class SyncController < AuthenticatedController

  def index
  end

  def synchronize
    alt_character = current_user.alt_characters.find_by_id(params[:alt_character_id])
    SynchronizeContacts.perform(user: current_user, alt: alt_character) if alt_character
    redirect_to sync_path
  end

end
