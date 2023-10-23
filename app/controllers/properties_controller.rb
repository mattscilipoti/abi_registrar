class PropertiesController < ApplicationController
  before_action :set_property, only: %i[ show edit update destroy ]

  # GET /properties or /properties.json
  def index
    properties = filter_models(Property, params[:q])
    @properties = properties.includes(:lots).decorate
  end

  # GET /properties/1 or /properties/1.json
  def show
  end

  # GET /properties/new
  def new
    @property = Property.new
  end

  # GET /properties/1/edit
  def edit
  end

  # POST /properties or /properties.json
  def create
    @property = Property.new(property_params)

    respond_to do |format|
      if @property.save
        format.html { redirect_to property_url(@property), notice: "Property was successfully created." }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /properties/1 or /properties/1.json
  def update
    respond_to do |format|
      # Convert toggleable_amentities_processed into today's date
      if params[:property] && params[:property][:amenities_processed] == '1'
        params[:property][:amenities_processed] = Time.zone.today
      end
      if params[:property] && params[:property][:lot_fees_paid]
        if params[:property][:lot_fees_paid] == '1'
          params[:property][:lot_fees_paid_on] = Time.zone.today
        else
          params[:property][:lot_fees_paid_on] = nil
        end
        params[:property].delete(:lot_fees_paid)
      end
      if @property.update(property_params)
        resulting_location = property_url(@property)
        # if update is from index, return to index
        resulting_location = request.referrer if request.referrer.present? && request.referrer.ends_with?('properties')
        format.html { redirect_to(resulting_location, notice: "Property was successfully updated.") }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1 or /properties/1.json
  def destroy
    @property.destroy

    respond_to do |format|
      format.html { redirect_to properties_url, notice: "Property was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(
        :amenities_processed,
        :for_sale,
        :lot_fees_paid,
        :lot_fees_paid_on,
        :membership_eligible,
        :section,
        :street_number,
        :street_name,
        :tax_identifier,
        :user_fee_paid_on,
        lot_ids: []
      )
    end
end
