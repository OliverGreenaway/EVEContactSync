class CreatePremiumPayment < ActiveRecord::Migration[5.1]
  def change
    create_table :premium_payments do |t|
      t.integer :user_id
      t.integer :amount
      t.datetime :paid_at
      t.string :payment_identifier
      t.integer :seconds_credited
      t.datetime :start_at
      t.integer :monthly_rate

      t.timestamps
    end
  end
end
