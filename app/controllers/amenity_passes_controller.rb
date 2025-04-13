class AmenityPassesController < ApplicationController
  skip_before_action :authenticate, only: [:index]
  before_action :set_amenity_pass, only: %i[confirm_void void]

  def index
    amenity_passes = filter_models(AmenityPass, params[:q])
    @amenity_passes = amenity_passes.decorate
  end

  # GET /amenity_passes/1/void
  def void
    if @amenity_pass.voided_at.present?
      redirect_to polymorphic_url(@amenity_pass), notice: "This Amenity Pass is already voided."
    else
      @amenity_pass.voided_at = Time.zone.now
      render :void
    end
  end

  # PATCH /amenity_passes/1/confirm_void
  def confirm_void
    if @amenity_pass.update(amenity_pass_params.merge(voided_at: Time.current))
      redirect_to polymorphic_url(@amenity_pass), notice: "Amenity Pass was successfully voided."
    else
      render :void, status: :unprocessable_entity
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def amenity_pass_params
      # Since this is polymorphic, we need to permit the voided_at and voided_reason attributes
      # for the specific amenity pass type.

      # Dynamically determine the parameter key based on the subclass of @amenity_pass.
      subclass_key = @amenity_pass.model_name.param_key.to_sym

      params.require(subclass_key).permit(
        :voided_at,
        :voided_reason
      )
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_amenity_pass
      @amenity_pass = AmenityPass.find(params[:id]).decorate
    end
end
