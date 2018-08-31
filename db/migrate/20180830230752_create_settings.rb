class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.boolean :sync_char_contacts, default: false
      t.boolean :sync_corp_contacts, default: false
      t.boolean :sync_ally_contacts, default: false
      t.integer :user_id
    end

    add_column :users, :settings_id, :integer
  end
end
