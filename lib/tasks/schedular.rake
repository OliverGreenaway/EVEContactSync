desc "Checks the EVE wallet and records any new premium payments"
task :record_payments => :environment do
  puts "Recording Payments..."
  RecordPayments.perform
  puts "Done."
end

desc "Updates Contacts for all Premium Users"
task :sync_contacts => :environment do
  puts "Syncing Premium Users Contacts..."

  puts "Done."
end
