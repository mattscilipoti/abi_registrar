require 'rails_helper'

RSpec.describe "layouts/_year_selector.html.slim", type: :view do
  let(:model) { AmenityPass }

  before do
    # Return a small deterministic set of years for the partial
    allow(view).to receive(:year_options).and_return([["2025", 2025], ["2024", 2024]])
    # Minimal params object so `url_for(params.permit!.to_h.merge(year: value))` works
    allow(view).to receive(:params).and_return(ActionController::Parameters.new({}))
    # Stub grouping/counts on the model to avoid hitting the DB in view specs
    allow(AmenityPass).to receive(:group).and_return(double(count: {}))
    allow(AmenityPass).to receive(:count).and_return(0)
    # Prevent url_for from trying to generate real routes in view specs
    allow(view).to receive(:url_for).and_return('#')
  end

  it "renders year links and list container" do
    render partial: "layouts/year_selector", locals: { model: model, compact: false }

    expect(rendered).to include('2025')
    expect(rendered).to include('2024')
    # Ensure aria-labels with pass counts are rendered for accessibility
    expect(rendered).to match(/aria-label=.*pass/)
    expect(rendered).to include('year-list')
  end

  it "renders the compact variant" do
    render partial: "layouts/year_selector", locals: { model: model, compact: true }

    expect(rendered).to include('year-list-small')
  end
end
