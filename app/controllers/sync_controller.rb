class SyncController < AuthenticatedController

  def index
    @char_contacts = EveSwaggerInterfaceService.new(current_user).character_contacts
  end

end
