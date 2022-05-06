class ApplicationController < ActionController::Base

  private

  def sort_models(models, sort_info)
    sort_column = sort_info[:column]
    sort_direction = sort_info[:direction]
    # models.order("#{sort_column} #{sort_direction}")

    # WORKAROUND: support sorting by non-AR columns
    # Yes, this is inefficient but our lists are small
    # Using format(), with leading zeros, to support sorting string, number, or TrueClass
    models = models.sort_by{|r| format('%010s' % r.send(sort_column).to_s)}
    if sort_direction != 'asc'
      models = models.reverse
    end
    models
  end

  helper_method :sort_models
end
