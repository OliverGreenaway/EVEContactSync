class AddContactHashesToAltCharacter < ActiveRecord::Migration[5.1]
  def change
    add_column :alt_characters, :char_contact_hash, :string, default: nil
    add_column :alt_characters, :corp_contact_hash, :string, default: nil
    add_column :alt_characters, :ally_contact_hash, :string, default: nil

    remove_column :users, :char_contact_hash
    remove_column :users, :corp_contact_hash
    remove_column :users, :ally_contact_hash
  end
end
