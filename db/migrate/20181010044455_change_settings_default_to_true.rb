class ChangeSettingsDefaultToTrue < ActiveRecord::Migration[5.1]
  def change
    change_column :settings, :sync_char_contacts, :boolean, default: true
    change_column :settings, :sync_corp_contacts, :boolean, default: true
    change_column :settings, :sync_ally_contacts, :boolean, default: true
  end
end
