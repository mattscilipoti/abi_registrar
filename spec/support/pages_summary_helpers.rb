module PagesSummaryHelpers
  # Return the passes table Nokogiri node from an HTML document
  def passes_table(doc)
    passes_h2 = doc.css('h2').find { |h| h.text.strip == 'Passes Summary' }
    return nil unless passes_h2
    passes_h2.ancestors('fieldset').first.at_css('table')
  end

  # Return the tbody tr node for a given model name (e.g., 'BeachPasses') inside the passes table
  def pass_row_for(doc, model_name)
    table = passes_table(doc)
    return nil unless table
    table.css('tbody tr').find { |tr| (tr.at_css('td a')&.text || '').strip == model_name }
  end

  # Return array of td nodes for a given model name in the passes table
  def pass_cells_for(doc, model_name)
    row = pass_row_for(doc, model_name)
    row ? row.css('td') : []
  end
end

RSpec.configure do |config|
  config.include PagesSummaryHelpers, type: :request
end
