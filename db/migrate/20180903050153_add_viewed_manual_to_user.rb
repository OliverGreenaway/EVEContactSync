class AddViewedManualToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :viewed_manual, :boolean, default: false
  end
end
