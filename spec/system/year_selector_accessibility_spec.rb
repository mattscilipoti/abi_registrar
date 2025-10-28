require 'rails_helper'

RSpec.describe 'Year selector accessibility', type: :system do
  before do
    driven_by :rack_test
  end

  it 'includes ARIA attributes and exposes focusable links' do
    account = Account.create!(email: "spec+#{SecureRandom.hex(6)}@example.org", status: :verified)
    account.password_hash = BCrypt::Password.create('password').to_s
    account.save!

    resident = FactoryBot.create(:resident)
    FactoryBot.create(:beach_pass, resident: resident, season_year: 2025, sticker_number: 'A-1')
    FactoryBot.create(:beach_pass, resident: resident, season_year: 2024, sticker_number: 'B-2')

    visit '/login'
    fill_in 'login', with: account.email
    within('form') { find('input[type=submit], button[type=submit]').click }

    visit amenity_passes_path

    # Nav has an accessible label
    expect(page).to have_selector('nav[aria-label="Season Year"]')

    # Year links exist and are anchors with href and visible text
    year_links = page.all('.year-list a')
    expect(year_links).not_to be_empty
    year_links.each do |a|
      expect(a[:href]).to be_present
      expect(a.text.strip).not_to be_empty
    end

    # Clicking a year should mark the active link with aria-current
    click_link '2024'
    active_links = page.all('.year-list a[aria-current="true"]')
    expect(active_links.map(&:text)).to include('2024')
  end
end
