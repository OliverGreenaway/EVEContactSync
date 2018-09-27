class CreateSyncJob < ActiveRecord::Migration[5.1]
  def change
    create_table :sync_jobs do |t|
      t.datetime :started_at
      t.datetime :finished_at, default: nil
      t.timestamps
    end
  end
end
