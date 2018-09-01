class AddCorpAndAllyNamesToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :corp_name, :string
    add_column :users, :corp_id, :string
    add_column :users, :ally_name, :string
    add_column :users, :ally_id, :string
  end
end
