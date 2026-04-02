module YearSelectorHelper
  # Returns an array of options for years with 'All' first.
  # Default range is AmenityPass.available_years
  def year_options(range: nil)
    # Normalize to an Array so callers may pass a Range or Array.
    range ||= AmenityPass.available_years
    years = Array(range)

    # Remove nils, uniquify, and sort newest-first for display.
    years = years.compact.uniq.sort.reverse

    # Build options: 'All', specific years, then 'None' (records with NULL season_year).
    options = [['All', 'all']] + years.map { |y| [y.to_s, y.to_s] } + [['None', 'none']]
    options
  end
end
