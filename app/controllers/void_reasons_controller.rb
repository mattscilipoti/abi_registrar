class VoidReasonsController < ApplicationController
  before_action :require_admin
  before_action :set_void_reason, only: %i[show edit update destroy]

  def index
    @void_reasons = VoidReason.order(:position, :label)
  end

  def new
    @void_reason = VoidReason.new
  end

  def create
    @void_reason = VoidReason.new(void_reason_params)
    if @void_reason.save
      redirect_to void_reasons_path, notice: 'Void reason created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @void_reason.update(void_reason_params)
      redirect_to void_reasons_path, notice: 'Void reason updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if AmenityPass.where(void_reason_id: @void_reason.id).exists?
      redirect_to void_reasons_path, alert: 'Cannot delete a reason that is referenced by amenity passes. Consider deactivating it instead.'
    else
      @void_reason.destroy
      redirect_to void_reasons_path, notice: 'Void reason deleted.'
    end
  end

  private

  def set_void_reason
    @void_reason = VoidReason.find(params[:id])
  end

  def void_reason_params
    params.require(:void_reason).permit(:label, :code, :active, :position, :pass_type, :requires_note)
  end

  # Minimal admin guard: only allow accounts listed on the Administrators page.
  # This app lists administrators via Accounts; using a simple allow-list from credentials for now.
  def require_admin
    # If you have a more robust admin system, replace this.
    admins = Array(Rails.application.credentials.dig(:admin_emails))
    if admins.blank?
      # Fallback: allow all logged-in users to reach the page if no admin list is configured.
      return if rodauth.logged_in?
    end

    unless rodauth.logged_in? && admins.include?(current_account.email)
      redirect_to root_path, alert: 'Not authorized.'
    end
  end
end
