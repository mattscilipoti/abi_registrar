class ResidentsController < ApplicationController
  before_action :set_resident, only: %i[ show edit update destroy ]

  # GET /residents or /residents.json
  def index
    residents = filter_models(Resident, params[:q])
    @residents = residents.decorate
  end

  # GET /residents/1 or /residents/1.json
  def show
  end

  # GET /residents/new
  def new
    @resident = Resident.new
    if params[:resident]
      property_id = resident_params[:residencies_attributes][:property_id]
      @property = Property.find(property_id)
      @resident.residencies.build(property: @property)
    end
  end

  # GET /residents/1/edit
  def edit
  end

  # POST /residents or /residents.json
  def create
    @resident = Resident.new(resident_params)

    respond_to do |format|
      if @resident.save
        format.html { redirect_to resident_url(@resident), notice: "Resident was successfully created." }
        format.json { render :show, status: :created, location: @resident }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @resident.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /residents/1 or /residents/1.json
  def update
    respond_to do |format|
      if @resident.update(resident_params)
        format.html { redirect_to resident_url(@resident), notice: "Resident was successfully updated." }
        format.json { render :show, status: :ok, location: @resident }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @resident.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /residents/1 or /residents/1.json
  def destroy
    @resident.destroy

    respond_to do |format|
      format.html { redirect_to residents_url, notice: "Resident was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resident
      @resident = Resident.find(params[:id]).decorate
    end

    # Only allow a list of trusted parameters through.
    def resident_params
      params.require(:resident).permit(
        :last_name,
        :middle_name,
        :first_name,
        :email_address,
        :phone,
        :is_minor,
        mailing_address: [:number, :road, :unit, :city, :state_code, :postal_code],
        residencies_attributes: [
          :id,
          :resident_id,
          :primary_residence,
          :property_id,
          :resident_status,
          :verified_on,
          :_destroy
        ]
      )
    end
end
