desc "Checks the EVE wallet and records any new premium payments"
task :record_payments => :environment do
  puts "Recording Payments..."
  RecordPayments.perform
  puts "Done."
end

desc "Updates Contacts for all Premium Users"
task :sync_contacts => :environment do
  if SyncJob.where(finished_at: nil).present?
    puts "Skipped Premium Sync as previous job is still running"
  else
    job = SyncJob.create(started_at: Time.now)

    puts "Syncing Premium Users Contacts..."
    errors = {}
    job_start = Time.now
    sync_count = 0
    User.select(&:premium?).each do |premium_user|
      next unless premium_user.settings.auto_sync_contacts
      premium_user.alt_characters.each do |alt_character|
        sync = SynchronizeContacts.perform(user: premium_user, alt: alt_character, source: :auto)
        sync_count += sync.total_syncs
        unless sync.success?
          errors[premium_user.id.to_s] ||= {}
          errors[premium_user.id.to_s][alt_character.id.to_s] = errors
        end
      end
    end
    unless errors.empty?
      puts "#{errors.keys.count} Errors:"
      puts errors
    end
    SyncStat.create(job_started: job_start, job_finished: Time.now, contact_count: sync_count, success: true, job_type: :scheduled)
    puts "Done."
    job.update(finished_at: Time.now)

    SyncJob.where('finished_at < ?', 1.week.ago).delete_all
  end
end
