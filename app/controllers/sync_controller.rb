class SyncController < AuthenticatedController

  def index
    esi_service = EveSwaggerInterfaceService.new(current_user)
    # @char_contacts = esi_service.character_contacts
    # @corp_contacts = esi_service.corporation_contacts
    # @ally_contacts = esi_service.alliance_contacts
  end

end
