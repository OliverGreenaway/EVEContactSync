class AddLastSyncToAltCharacter < ActiveRecord::Migration[5.1]
  def change
    add_column :alt_characters, :last_sync, :datetime
  end
end
