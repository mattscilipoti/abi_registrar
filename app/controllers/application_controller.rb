class ApplicationController < ActionController::Base

  private

  def sort_models(models, default_sort_column, sort_info)
    sort_column = sort_info[:column]
    sort_direction = sort_info[:direction]
    # models.order("#{sort_column} #{sort_direction}")
    
    # WORKAROUND: support sorting my non-AR columns
    # Yes, this is inefficient but our lists are small
    # Using format() to support sorting string, number, or TrueClass
    models = models.all.sort_by{|r| format('%010s' % r.send(sort_column).to_s)}
    if sort_direction != 'asc'  
      models = models.reverse
    end
    models
  end
end
