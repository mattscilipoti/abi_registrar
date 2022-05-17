class ApplicationController < ActionController::Base

  private

  def filter_models(model, search_query)
    if search_query.blank?
      properties = model.all
    else
      case search_query
      when /not.paid/i
        properties = model.not_paid
      when /problematic/i
        properties = model.problematic
      else
        properties = model.search_by_all(params[:q])
      end
    end
  end
end
