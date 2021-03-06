require 'digest'
class SynchronizeContacts
  include UseCase

  attr_reader :total_syncs

  def initialize(user:, alt:, source:)
    @sync_stat = SyncStat.create(job_started: Time.now, job_type: source)
    @user = user
    @alt = alt
    @total_syncs = 0
  end

  def perform
    if(@alt.last_sync.nil? || @alt.last_sync < (Time.now - 5.minutes))
      synchronize_character_contacts if @user.settings.sync_char_contacts
      synchronize_corporation_contacts if @user.settings.sync_corp_contacts
      synchronize_alliance_contacts if @user.settings.sync_ally_contacts
      if @user.settings.sync_char_contacts || @user.settings.sync_corp_contacts || @user.settings.sync_ally_contacts
        @alt.update(last_sync: Time.now)
      else
        errors[:sync] << "No contacts synchronized, ensure you have enabled syncing of at least one contact type in settings."
      end
    else
      errors[:sync] << "#{@alt.name} not Synced, Each Alt Character can only be synced every 5 minutes."
    end
    @sync_stat.update(job_finished: Time.now, success: true, contact_count: @total_syncs)
  end

  private

  def synchronize_character_contacts
    char_contacts = main_esi_service.character_contacts
    hashed_contacts = Digest::SHA1.hexdigest(char_contacts.to_s)
    if hashed_contacts != @alt.char_contact_hash
      sync_contacts(char_contacts)
      @alt.update(char_contact_hash: hashed_contacts)
    end
  end

  def synchronize_corporation_contacts
    corp_contacts = main_esi_service.corporation_contacts
    hashed_contacts = Digest::SHA1.hexdigest(corp_contacts.to_s)
    if hashed_contacts != @alt.corp_contact_hash
      sync_contacts(corp_contacts)
      @alt.update(corp_contact_hash: hashed_contacts)
    end
  end

  def synchronize_alliance_contacts
    ally_contacts = main_esi_service.alliance_contacts
    hashed_contacts = Digest::SHA1.hexdigest(ally_contacts.to_s)
    if hashed_contacts != @alt.ally_contact_hash
      sync_contacts(ally_contacts)
      @alt.update(ally_contact_hash: hashed_contacts)
    end
  end

  def sync_contacts(contacts)
    sorted_contacts = seperate_by_standing(contacts)
    labels = []
    if @user.premium? && @alt.label_id != AltCharacter::DEFAULT_LABEL["label_id"]
      if alt_esi_service.contact_labels.detect {|l| l["label_id"] == @alt.label_id }.present?
        labels = @alt.label_id
      end
    end

    sorted_contacts.each do |standing,contact_ids|
      contact_ids.each_slice(100) do |contact_slice|
        alt_esi_service.create_contacts(standing: standing, contacts: contact_slice, labels: labels)
        alt_esi_service.update_contacts(standing: standing, contacts: contact_slice, labels: labels)
        @total_syncs += contact_slice.count
      end
    end
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
