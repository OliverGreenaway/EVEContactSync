class CreateAltCharacter < ActiveRecord::Migration[5.1]
  def change
    create_table :alt_characters do |t|
      t.string :provider
      t.string :uid

      t.string :name
      t.integer :character_id

      t.string :token
      t.string :refresh_token
      t.integer :token_expiry

      t.integer :user_id

      t.timestamps null: false
    end
  end
end
