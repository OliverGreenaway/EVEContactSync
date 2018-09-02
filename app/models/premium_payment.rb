class PremiumPayment < ApplicationRecord
  belongs_to :user
  COST_PER_MONTH = 10000000

  def end_at
    start_at + seconds_credited.seconds
  end
end
