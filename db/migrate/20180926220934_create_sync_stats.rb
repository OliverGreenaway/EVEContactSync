class CreateSyncStats < ActiveRecord::Migration[5.1]
  def change
    create_table :sync_stats do |t|
      t.datetime :job_started
      t.datetime :job_finished
      t.integer :contact_count
      t.boolean :success, default: false
      t.string :job_type
      t.timestamps
    end
  end
end
