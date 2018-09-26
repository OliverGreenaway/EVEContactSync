class AddAutoSyncSwitchToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :auto_sync_contacts, :boolean, default: false
  end
end
