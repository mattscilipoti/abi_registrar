require 'rails_helper'

RSpec.describe "Pages#summary", type: :request do
  it "renders items and passes tables and shows pass quantities and distinct residents" do
    year = Time.zone.now.year

    # Sign in via rodauth (establishes session cookie)
    account = create_account
    sign_in_request_via_rodauth(account)

    # Create a resident and some passes for the current year
    resident = Resident.create!(last_name: "Spec")
    # Create a property and residency and mark fees paid so pass validations succeed
    property = Property.create!(street_name: 'Spec St', tax_identifier: '12 345 00000001', lot_fees_paid_on: Date.today, user_fee_paid_on: Date.today)
    Residency.create!(property: property, resident: resident)

    AmenityPass.create!(resident: resident, sticker_number: 'A1', season_year: year)
    BeachPass.create!(resident: resident, sticker_number: 'B1', season_year: year)

    # Also create a pass in a different year to test filtering
    prev_year = year - 1
    BeachPass.create!(resident: resident, sticker_number: 'B2', season_year: prev_year)

    # Create a second resident with a BeachPass in the current year to test distinct resident counts
    resident2 = Resident.create!(last_name: "Spec2")
    Residency.create!(property: property, resident: resident2)
    BeachPass.create!(resident: resident2, sticker_number: 'B3', season_year: year)

    # When requesting the current year, BeachPasses should show 1
    get summary_path(year: year)
    expect(response).to have_http_status(:ok)
    doc = Nokogiri::HTML(response.body)
    cells = pass_cells_for(doc, 'BeachPasses')
    expect(cells).not_to be_empty
    expect(cells[1].text.strip).to eq('2')
    # distinct residents for current year should be 2
    expect(cells[2].text.strip).to eq('2')

    # When requesting the previous year, BeachPasses should show 1 (the prev_year pass)
    get summary_path(year: prev_year)
    expect(response).to have_http_status(:ok)
    doc = Nokogiri::HTML(response.body)
    cells = pass_cells_for(doc, 'BeachPasses')
    expect(cells).not_to be_empty
    expect(cells[1].text.strip).to eq('1')
    # distinct residents for prev year should be 1
    expect(cells[2].text.strip).to eq('1')

    # When requesting 'all' years, BeachPasses should show 2
    get summary_path(year: 'all')
    expect(response).to have_http_status(:ok)
    doc = Nokogiri::HTML(response.body)
    cells = pass_cells_for(doc, 'BeachPasses')
    expect(cells).not_to be_empty
    expect(cells[1].text.strip).to eq('3')
    # distinct residents for 'all' should be 2 (resident and resident2)
    expect(cells[2].text.strip).to eq('2')
  end
end
