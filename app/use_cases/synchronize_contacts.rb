class SynchronizeContacts
  include UseCase

  def initialize(user:, alt:)
    @user = user
    @alt = alt
    @total_syncs = 0
  end

  def perform
    if(@alt.last_sync.nil? || @alt.last_sync < (Time.now - 5.minutes))
      synchronize_character_contacts if @user.settings.sync_char_contacts
      synchronize_corporation_contacts if @user.settings.sync_corp_contacts
      synchronize_alliance_contacts if @user.settings.sync_ally_contacts
      if @total_syncs == 0
        errors[:sync] << "No contacts synchronized, ensure you have enabled syncing of at least one contact type in settings."
      else
        @alt.update(last_sync: Time.now)
      end
    else
      errors[:sync] << "#{@alt.name} not Synced, Each Alt Character can only be synced every 5 minutes."
    end
  end

  private

  def synchronize_character_contacts
    sync_contacts(main_esi_service.character_contacts)
  end

  def synchronize_corporation_contacts
    sync_contacts(main_esi_service.corporation_contacts)
  end

  def synchronize_alliance_contacts
    sync_contacts(main_esi_service.alliance_contacts)
  end

  def sync_contacts(contacts)
    sorted_contacts = seperate_by_standing(contacts)

    sorted_contacts.each do |standing,contact_ids|
      contact_ids.each_slice(100) do |contact_slice|
        alt_esi_service.create_contacts(standing: standing, contacts: contact_slice)
      end
    end
    @total_syncs += 1
  end

  def seperate_by_standing(contacts)
    standing_hash = {}
    contacts.each do |contact|
      standing_hash[contact["standing"]] ||= []
      standing_hash[contact["standing"]] << contact["contact_id"]
    end
    standing_hash
  end

  def main_esi_service
    @main_esi_service ||= EveSwaggerInterfaceService.new(@user)
  end

  def alt_esi_service
    @alt_esi_service ||= EveSwaggerInterfaceService.new(@alt)
  end

end
