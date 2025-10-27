module YearSelectorHelper
  # Returns an array of options for years with 'All' first.
  # If a `model:` is provided and responds to `available_years`, use that list.
  # Otherwise fall back to a default recent range (current year and previous 4 years).
  def year_options(model: nil, range: (Time.zone.now.year - 4)..Time.zone.now.year)
    if model && model.respond_to?(:available_years)
      years = model.available_years
    else
      years = range.to_a.reverse
    end

    options = [['All', 'all']] + years.map { |y| [y.to_s, y.to_s] }
    options
  end
end
