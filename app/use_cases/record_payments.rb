class RecordPayments
  include UseCase

  def perform
    get_journal
    retrieve_payments_not_recorded
    record_payments
  end

  private

  def get_journal
    @journal = esi_client.wallet_journal
  end

  def retrieve_payments_not_recorded
    @payments_requiring_record = []
    @journal.each do |entry|
      unless PremiumPayment.where(payment_identifier: entry['id'].to_s).present?
        @payments_requiring_record << entry
      end
    end
  end

  def record_payments
    @payments_requiring_record.each do |entry|
      if entry['amount'] >= PremiumPayment::COST_PER_MONTH && user = User.find_by_character_id(entry['first_party_id'])
        PremiumPayment.create(
          user: user,
          start_at: (user.premium? ? user.premium_expires_at : Time.now),
          amount: entry['amount'],
          paid_at: Time.parse(entry['date']),
          payment_identifier: entry['id'].to_s,
          seconds_credited: (((entry['amount'] - (entry['amount'] % PremiumPayment::COST_PER_MONTH)) / PremiumPayment::COST_PER_MONTH) * 2592000),
          monthly_rate: PremiumPayment::COST_PER_MONTH
        )
      end
    end
  end

  def esi_client
    @esi_client ||= EveSwaggerInterfaceService.new(User.find_by_role('admin'))
  end

end
