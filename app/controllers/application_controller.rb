class ApplicationController < ActionController::Base

  private

  def filter_models(model, search_query)
    if search_query.blank?
      model.all
    else
      case search_query
      when '🚫'
        model.where(id: 0) # none
      when /not.paid/i
        model.not_paid
      when /problematic/i
        model.problematic
      when *model.scopes.collect(&:to_s)
        # send the scope name as a method name
        logger.info("Filtering by scope: #{search_query.inspect}")
        model.send(search_query)
      else
        logger.info("Full-text search for: #{search_query.inspect}")
        model.search_by_all(params[:q])
      end
    end
  end
end
