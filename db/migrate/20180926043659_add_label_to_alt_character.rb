class AddLabelToAltCharacter < ActiveRecord::Migration[5.1]
  def change
    add_column :alt_characters, :label_id, :integer, default: AltCharacter::DEFAULT_LABEL["label_id"]
    add_column :alt_characters, :label_name, :string, default: AltCharacter::DEFAULT_LABEL["label_name"]
  end
end
