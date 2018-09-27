class SyncStat < ApplicationRecord
  JOB_TYPES = {scheduled: 'Scheduled Job', auto: 'Auto Sync', manual: 'Manual Sync'}
end
