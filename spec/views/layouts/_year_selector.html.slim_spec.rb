require 'rails_helper'

RSpec.describe "layouts/_year_selector.html.slim", type: :view do
  let(:model) { AmenityPass }

  before do
    # Return a small deterministic set of years for the partial
    allow(view).to receive(:year_options).and_return([["2025", 2025], ["2024", 2024]])
    # Minimal params object so `url_for(params.permit!.to_h.merge(year: value))` works
    allow(view).to receive(:params).and_return(ActionController::Parameters.new({}))
  end

  it "renders year links and list container" do
    render partial: "layouts/year_selector", locals: { model: model, compact: false }

    expect(rendered).to include('2025')
    expect(rendered).to include('2024')
    expect(rendered).to include('year-list')
  end

  it "renders the compact variant" do
    render partial: "layouts/year_selector", locals: { model: model, compact: true }

    expect(rendered).to include('year-list-small')
  end
end
