class AddContactHashesToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :char_contact_hash, :string, default: nil
    add_column :users, :corp_contact_hash, :string, default: nil
    add_column :users, :ally_contact_hash, :string, default: nil
  end
end
