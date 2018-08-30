# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid

      t.string :name
      t.integer :character_id

      t.string :token
      t.string :refresh_token
      t.integer :token_expiry

      t.timestamps null: false
    end
  end
end
