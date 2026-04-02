class PagesController < ApplicationController
  include RequireYearParam

  skip_before_action :authenticate, only: [:home]

  def home
    if rodauth.logged_in?
      redirect_to summary_path()
    else
      redirect_to amenity_passes_path()
    end
  end

  def summary
    # Ensure we have an explicit year value (RequireYearParam will redirect if missing)
    @year = params[:year]

    # Models to display in the summary, keep same order as the view expects
    item_models = [Lot, Property, Resident]
    pass_models = [AmenityPass, BeachPass, BoatRampAccessPass, DinghyDockStoragePass, UtilityCartPass, VehicleParkingPass, WatercraftStoragePass]

    # Builder for item models (Lot, Property, Resident) — include fee/amenities counts
    build_item_entry = lambda do |model|
      relation = model.all

      quantity = relation.count

      lot_fees_paid_count = relation.respond_to?(:lot_fees_paid) ? relation.lot_fees_paid.count : nil
      user_fee_paid_count = relation.respond_to?(:user_fee_paid) ? relation.user_fee_paid.count : nil
      amenities_processed_count = relation.respond_to?(:amenities_processed) ? relation.amenities_processed.count : nil

      last_updated = relation.maximum(:updated_at)

      {
        model: model,
        name: model.name.pluralize,
        path: url_for(model.name.tableize),
        quantity: quantity,
        lot_fees_paid_count: lot_fees_paid_count,
        user_fee_paid_count: user_fee_paid_count,
        amenities_processed_count: amenities_processed_count,
        last_updated: last_updated
      }
    end

    # Builder for pass models (AmenityPass and subclasses) — include distinct resident counts
    build_pass_entry = lambda do |model|
      relation = if model.respond_to?(:by_year)
                   model.by_year(@year)
                 else
                   model.all
                 end

      quantity = relation.count
      distinct_residents = relation.select(:resident_id).distinct.count
      last_updated = relation.maximum(:updated_at)

      {
        model: model,
        name: model.name.pluralize,
        path: url_for(model.name.tableize),
        quantity: quantity,
        distinct_residents: distinct_residents,
        last_updated: last_updated
      }
    end

    @summary_basic_entries = item_models.map(&build_item_entry)
    @summary_pass_entries = pass_models.map(&build_pass_entry)
  end
end
