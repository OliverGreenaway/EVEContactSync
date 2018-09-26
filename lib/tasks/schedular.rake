desc "Checks the EVE wallet and records any new premium payments"
task :record_payments => :environment do
  puts "Recording Payments..."
  RecordPayments.perform
  puts "Done."
end

desc "Updates Contacts for all Premium Users"
task :sync_contacts => :environment do
  puts "Syncing Premium Users Contacts..."
  errors = {}
  User.select(&:premium?).each do |premium_user|
    next unless premium_user.settings.auto_sync_contacts
    premium_user.alt_characters.each do |alt_character|
      sync = SynchronizeContacts.perform(user: premium_user, alt: alt_character)
      unless sync.success?
        errors[premium_user.id][alt_character.id] = errors
      end
    end
  end
  unless errors.empty?
    puts "#{errors.keys.count} Errors:"
    puts errors
  end
  puts "Done."
end
