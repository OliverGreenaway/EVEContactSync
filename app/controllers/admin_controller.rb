class AdminController < AuthenticatedController
  before_action :ensure_admin

  def index
    esi_service = EveSwaggerInterfaceService.new(current_user)
    @wallet_balance = esi_service.wallet_balance
    @wallet_journal = esi_service.wallet_journal
  end

  private

  def ensure_admin
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
